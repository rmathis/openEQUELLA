import { Typography } from "@material-ui/core";
import Paper from "@material-ui/core/Paper";
import { Theme, makeStyles } from "@material-ui/core/styles";
import * as React from "react";
import { ReactNode, FunctionComponent } from "react";

interface ErrorProps {
  children?: ReactNode;
}

const useStyles = makeStyles((theme: Theme) => ({
  error: {
    padding: theme.spacing(3),
    backgroundColor: "rgb(255, 220, 220)",
  },
}));

const Error: FunctionComponent<ErrorProps> = ({children}: ErrorProps) => {
  const classes = useStyles();
  return(
    <Paper className={ classes.error } >
      <Typography color="error" align="center">
        {children}
      </Typography>
    </Paper>
  );
}

export default Error;
