import {
  IconButton,
  ListItem,
  ListItemSecondaryAction,
  ListItemText,
  Theme
} from "@material-ui/core";
import Typography from "@material-ui/core/Typography";
import DeleteIcon from "@material-ui/icons/Delete";
import * as React from "react";
import { FunctionComponent } from "react";
import { LocationDescriptor } from "history";
import { Link } from "react-router-dom";
import { makeStyles } from "@material-ui/core/styles";

const useStyles = makeStyles((theme: Theme) => ({
  searchResultContent: {
    marginTop: theme.spacing(1),
  },
  itemThumb: {
    maxWidth: "88px",
    maxHeight: "66px",
    marginRight: "12px",
  },
  displayNode: {
    padding: 0,
  },
  details: {
    marginTop: theme.spacing(1),
  },
}));

export interface SearchResultExtraDetail {
  label: string;
  value: string;
}

export interface SearchResultProps {
  onClick: (e: React.MouseEvent<HTMLDivElement>) => void;
  to: LocationDescriptor;
  onDelete?: () => void;
  primaryText: string;
  secondaryText?: string;
}

const SearchResult: FunctionComponent<SearchResultProps> = (props: SearchResultProps) => {
  const { onDelete, to, primaryText, secondaryText, onClick } = props;
  const classes = useStyles();
  const link = (
    <Typography
      color="primary"
      variant="subtitle1"
      component={(p) => (
        <Link {...p} to={to}>
          {primaryText}
        </Link>
      )}
    />
  );

  const content = (
    <Typography
      variant="body1"
      className={classes.searchResultContent}
    >
      {secondaryText}
    </Typography>
  );
  return (
    <ListItem button onClick={onClick} divider>
      <ListItemText disableTypography primary={link} secondary={content} />
      <ListItemSecondaryAction>
        {onDelete && (
          <IconButton onClick={onDelete}>
            <DeleteIcon />
          </IconButton>
        )}
      </ListItemSecondaryAction>
    </ListItem>
  );
}

export default SearchResult;
