import { FormControl, FormLabel, MenuItem, Select } from "@material-ui/core";
import { SortOrder } from "../SearchSettingsModule";
import * as React from "react";
import { languageStrings } from "../../../util/langstrings";

export interface DefaultSortOrderSettingProps {
  disabled: boolean;
  value: SortOrder;
  setValue: (order: SortOrder) => void;
}
export default function DefaultSortOrderSetting({
  disabled,
  value,
  setValue
}: DefaultSortOrderSettingProps) {
  const searchPageSettingsStrings =
    languageStrings.settings.searching.searchPageSettings;
  return (
    <FormControl>
      <FormLabel>{searchPageSettingsStrings.defaultSortOrder}</FormLabel>
      <Select
        SelectDisplayProps={{ id: "_sortOrder" }}
        disabled={disabled}
        onChange={event => setValue(event.target.value as SortOrder)}
        variant={"standard"}
        value={value}
      >
        <MenuItem value={SortOrder.RANK}>
          {searchPageSettingsStrings.relevance}
        </MenuItem>
        <MenuItem value={SortOrder.DATEMODIFIED}>
          {searchPageSettingsStrings.lastModified}
        </MenuItem>
        <MenuItem value={SortOrder.DATECREATED}>
          {searchPageSettingsStrings.dateCreated}
        </MenuItem>
        <MenuItem value={SortOrder.NAME}>
          {searchPageSettingsStrings.title}
        </MenuItem>
        <MenuItem value={SortOrder.RATING}>
          {searchPageSettingsStrings.userRating}
        </MenuItem>
      </Select>
    </FormControl>
  );
}