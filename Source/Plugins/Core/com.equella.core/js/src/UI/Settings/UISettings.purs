module OEQ.UI.Settings.UISettings where

import Prelude

import Common.Strings (languageStrings)
import Control.Monad.Reader (runReaderT)
import Control.Monad.Trans.Class (lift)
import Data.Either (either)
import Data.Lens.Record (prop)
import Data.Lens.Setter (set)
import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
import Dispatcher (affAction)
import Dispatcher.React (getProps, getState, modifyState, renderer)
import Effect (Effect)
import Effect.Aff (Fiber, Milliseconds(..), delay, error, forkAff, killFiber)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Uncurried (mkEffectFn2)
import MaterialUI.Button (button)
import MaterialUI.Enums (contained)
import MaterialUI.ExpansionPanelDetails (expansionPanelDetails_)
import MaterialUI.FormControl (formControl_)
import MaterialUI.FormControlLabel (formControlLabel')
import MaterialUI.Styles (withStyles)
import MaterialUI.Switch (switch')
import Network.HTTP.Affjax (get, put_)
import Network.HTTP.Affjax.Request (json)
import Network.HTTP.Affjax.Response (json) as Resp
import OEQ.Data.Settings (UISettings, decodeUISettings, encodeUISettings)
import OEQ.Environment (baseUrl)
import OEQ.MainUI.TSRoutes (link, routes)
import React (ReactElement, component, unsafeCreateLeafElement)
import React.DOM (text)
import React.DOM as D
import React.DOM.Props as DP
import Web.HTML (window)
import Web.HTML.Location (replace)
import Web.HTML.Window (location)


data Command = LoadSetting | SetNewUI Boolean | SetNewSearch Boolean
type State eff = {
  disabled :: Boolean,
  settings :: UISettings,
  newUIEnabled :: Boolean,
  saving :: Maybe (Fiber Unit)
}

initialState :: forall eff. State eff
initialState = {disabled:true, saving:Nothing, newUIEnabled: false, settings: {newUI: {enabled:false, newSearch: false}}}

uiSettingsEditor :: {refreshUser :: Effect Unit} -> ReactElement
uiSettingsEditor = unsafeCreateLeafElement $ withStyles styles $ component "UISettings" $ \this -> do 
  let
    d = eval >>> affAction this
    string = languageStrings.uiconfig
    _newSearch = prop (SProxy :: SProxy "newSearch")
    _enabled = prop (SProxy :: SProxy "enabled")
    _newUI = prop (SProxy :: SProxy "newUI")
    _settings = prop (SProxy :: SProxy "settings")
    _name = prop (SProxy :: SProxy "name")
    _path = prop (SProxy :: SProxy "path")
    _newUISettings = _settings <<< _newUI 

    render {state: s@{settings:uis@{newUI}}, props: {classes}} =
      let
        disabled = not newUI.enabled
      in
      expansionPanelDetails_ [
        D.div' [
          D.div [DP.className classes.enableColumn] $[
            formControl_ [
              formControlLabel' { label: string.enableNew, control: switch' { checked: s.newUIEnabled,
                              disabled: s.disabled, onChange: mkEffectFn2 $ \e -> d <<< SetNewUI} }
            ]
          ],
          D.div'[
            D.div [DP.className classes.facetColumn] $ [
              formControl_ [
                formControlLabel' {label: string.enableSearch, control: switch' {checked: newUI.newSearch,
                               disabled, onChange: mkEffectFn2 \e -> d <<< SetNewSearch }}
              ]
            ],
            link {to: routes."ThemeConfig".path} [
              button
                {variant: contained, disabled}
                [text string.themeSettingsButton]
            ]
          ]
        ]
      ]
    save = do
      {saving} <- getState
      {refreshUser} <- getProps
      newFiber <- lift $ forkAff $ do
        delay (Milliseconds 100.0)
        {settings} <- runReaderT getState this
        void $ put_ (baseUrl <> "api/settings/ui") $ json $ encodeUISettings settings
        liftEffect refreshUser
      modifyState _{saving=Just newFiber}
      lift $ maybe (pure unit) (killFiber (error "")) saving

    eval LoadSetting = do
      result <- lift $ get Resp.json $ baseUrl <> "api/settings/ui"
      either (lift <<< log) (\r -> modifyState _ {settings=r, newUIEnabled=r.newUI.enabled, disabled=false}) $ decodeUISettings result.response
    eval (SetNewUI v) = do
      {settings} <- getState
      modifyState _ {newUIEnabled = v}
      lift $ void $ put_ (baseUrl <> "api/settings/ui") $ json $ encodeUISettings $ set (_newUI <<< _enabled) v settings
      liftEffect $ do 
        l <- window >>= location
        replace (baseUrl <> "access/settings.do") l
    eval (SetNewSearch v) = do
      modifyState $ set (_newUISettings <<< _newSearch) v
      save
  pure {state:initialState, render: renderer render this, componentDidMount: d LoadSetting}
  where 
    styles theme = {
      fab: {
        position: "absolute",
        bottom: 0,
        right: 16
      },
      enableColumn: {
        flexBasis: "33.3%"
      },
      facetColumn: {
        flexBasis: "50%"
      },
      facetConfig: {
        position:"relative",
        paddingBottom: 64
      },
      pathField: {
        marginLeft: theme.spacing.unit,
        marginRight: theme.spacing.unit,
        width: 300
      }
    }
