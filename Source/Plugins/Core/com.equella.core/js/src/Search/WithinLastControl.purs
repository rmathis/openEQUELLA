module OEQ.Search.WithinLastControl where 

import Prelude

import Common.Strings (languageStrings)
import Data.Argonaut (Json, _Number)
import Data.Array as Array
import Data.DateTime.Instant (instant, toDateTime, unInstant)
import Data.Either (fromRight)
import Data.Foldable (find)
import Data.Formatter.DateTime (Formatter, format, parseFormatString)
import Data.Lens (Lens', _Just, preview, set)
import Data.Lens.At (at)
import Data.Map (Map)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (unwrap)
import Data.Time.Duration (class Duration, Days(..), Milliseconds(..), fromDuration)
import Data.Tuple (Tuple(..))
import Effect.Now (now)
import Effect.Unsafe (unsafePerformEffect)
import MaterialUI.Icon (icon_)
import MaterialUI.MenuItem (menuItem)
import MaterialUI.Styles (withStyles)
import MaterialUI.TextField (textField)
import OEQ.Search.SearchControl (Chip(..), Placement, SearchControl)
import OEQ.Search.SearchQuery (Query, QueryParam, ParamData, _data, _params, emptyQueryParam, singleParam)
import OEQ.UI.Common (valueChange)
import OEQ.UI.SearchFilters (filterSection)
import Partial.Unsafe (unsafePartial)
import React (statelessComponent, unsafeCreateLeafElement)
import React.DOM (em', text)

type AgoEntry = {name::String, emmed::Boolean, duration::Milliseconds}

dateFormat :: Formatter
dateFormat = unsafePartial $ fromRight $ parseFormatString "YYYY-MM-DDTHH:mm:ss"


beforeLast :: Number -> {data::Json, value::QueryParam}
beforeLast 0.0 = emptyQueryParam 0.0
beforeLast ms = 
  let nowInst = unsafePerformEffect now
      beforeStr = format dateFormat $ toDateTime $ fromMaybe nowInst $ instant $ 
              Milliseconds $ unwrap (unInstant nowInst) - ms
  in singleParam ms "modifiedAfter" beforeStr

milliToAgo :: Milliseconds -> String
milliToAgo s = fromMaybe "" $ _.name <$> find (_.duration >>> eq s) agoEntries

ago :: forall a. Duration a => String -> a -> AgoEntry
ago name d = {name, emmed:false, duration: fromDuration d}

agoEntries :: Array AgoEntry
agoEntries = let s = languageStrings.searchpage.filterLast in [
  (ago s.none (Milliseconds 0.0)) {emmed=true},
  ago s.day (Days 1.0), 
  ago s.week (Days 7.0),
  ago s.month (Days 28.0),
  ago s.year (Days 365.0),
  ago s.fiveyear (Days $ 365.0 * 5.0)
]

setModifiedWithin :: Number -> Query -> Query 
setModifiedWithin = set (_params <<< _modifiedLast) <<< Just <<< beforeLast

_modifiedLast :: Lens' (Map String ParamData) (Maybe ParamData)
_modifiedLast = at "modifiedLast"

withinLastControl :: Placement -> SearchControl
withinLastControl placement =
  let 
    string = languageStrings.searchpage
    agoItem {name,emmed,duration:(Milliseconds ms)} = menuItem {value:ms} $ 
        (if emmed then pure <<< em' else identity) [text name]
    agoMs query = preview (_modifiedLast <<< _Just <<< _data <<< _Number) query.params
    updateMs updateQuery ms = updateQuery $ setModifiedWithin ms
    render {classes,query,updateQuery} = 
        filterSection {
          name:string.filterLast.name, 
          icon: icon_ [text "calendar_today"]
        } [ 
          textField {select:true, 
            label: string.filterLast.label, 
            className: classes.selectFilter, 
            value: fromMaybe 0.0 $ agoMs query,
            onChange: valueChange $ updateMs updateQuery
            } $ (agoItem <$> agoEntries)
        ]

    withinClass = withStyles styles $ statelessComponent render
    renderer {query,updateQuery} = pure {
      render: [Tuple placement $ unsafeCreateLeafElement withinClass {query,updateQuery}],
      chips: Array.fromFoldable $ agoMs query >>= case _ of 
        0.0 -> Nothing 
        ms -> Just $ Chip { label: string.filterLast.chip <> milliToAgo (Milliseconds ms), 
                            onDelete: updateMs updateQuery 0.0}
    }
    in renderer
  where 
  styles theme = {
    selectFilter: {
      width: "15em"
    }
  }