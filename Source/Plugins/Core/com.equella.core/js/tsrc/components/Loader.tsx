import CircularProgress from "@material-ui/core/CircularProgress";
import {
  Theme,
  makeStyles,
} from "@material-ui/core/styles";
import * as React from "react";
import { FunctionComponent } from "react";

const useStyles = makeStyles((theme: Theme) => ({
    container: {
      position: "relative",
      width: "100%",
      height: "100%",
    },
    loader: {
      position: "absolute",
      width: 100,
      height: 100,
      margin: "auto",
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
    }
}));

interface LoaderProps {}


const Loader: FunctionComponent<LoaderProps> = (props: LoaderProps) => {
  const classes = useStyles();
  return (
    <div className={classes.container}>
      <div className={classes.loader}>
        <CircularProgress size={100} thickness={5} color="secondary" />
      </div>
    </div>
  );
}

export default Loader;
