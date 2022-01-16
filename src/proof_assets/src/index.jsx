import * as React from "react";
import { render } from "react-dom";
// import { custom_greeting } from "../../declarations/custom_greeting";

const MyHello = () => {


  return (
    <h1>Hello world</h1>
  );
};

render(<MyHello />, document.getElementById("app"));