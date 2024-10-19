within EHPTlib.MapBased;

package ECUs
  model PsdEcu1 "Power Split hybrid power train controller, not using ON/OFF strategy"
    extends Partial.PartialEcu;
  equation
    connect(powFilt.y, powToWref.u) annotation(
      Line(points = {{26, 39}, {26, 20}, {-40, 20}, {-40, -58}, {-10, -58}}, color = {0, 0, 127}));
    connect(powFilt.y, conn.icePowRef) annotation(
      Line(points = {{26, 39}, {26, 20}, {42, 20}, {42, 72}, {0, 72}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-3, -6}, {-3, -6}}, horizontalAlignment = TextAlignment.Right));
    annotation(
      Icon(graphics = {Text(extent = {{-100, 86}, {100, 56}}, textString = "PSD-ecu1")}));
  end PsdEcu1;

  model PsdEcu2 "Power Split hybrid power train controller, with SOC control, without ON/OFF"
    extends Partial.PartialEcu;
    parameter Real socRef = 0.6 "Target value of SOC";
    parameter Modelica.Units.SI.Power socLoopGain = 10000 "soc loop gain";
    Modelica.Blocks.Math.Feedback fbSOC annotation(
      Placement(transformation(extent = {{-58, 34}, {-38, 14}})));
    Modelica.Blocks.Sources.Constant socRef_(k = socRef) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-62, -6})));
    Modelica.Blocks.Math.Gain socErrToPow(k = socLoopGain) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-18, 24})));
    Modelica.Blocks.Math.Add add annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {20, 4})));
  equation
    connect(socRef_.y, fbSOC.u1) annotation(
      Line(points = {{-62, 5}, {-62, 24}, {-56, 24}}, color = {0, 0, 127}));
    connect(fbSOC.y, socErrToPow.u) annotation(
      Line(points = {{-39, 24}, {-30, 24}}, color = {0, 0, 127}));
    connect(socErrToPow.y, add.u2) annotation(
      Line(points = {{-7, 24}, {14, 24}, {14, 16}}, color = {0, 0, 127}));
    connect(add.y, powToWref.u) annotation(
      Line(points = {{20, -7}, {20, -20}, {-26, -20}, {-26, -58}, {-10, -58}}, color = {0, 0, 127}));
    connect(powFilt.y, add.u1) annotation(
      Line(points = {{26, 39}, {26, 16}}, color = {0, 0, 127}));
    connect(add.y, conn.icePowRef) annotation(
      Line(points = {{20, -7}, {20, -20}, {42, -20}, {42, 74}, {0, 74}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-3, -6}, {-3, -6}}, horizontalAlignment = TextAlignment.Right));
    connect(fbSOC.u2, conn.batSOC) annotation(
      Line(points = {{-48, 32}, {-48, 80}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-3, 6}, {-3, 6}}, horizontalAlignment = TextAlignment.Right));
    annotation(
      Icon(graphics = {Text(extent = {{-100, 88}, {100, 58}}, textString = "PSD-ecu2", textColor = {0, 0, 0})}));
  end PsdEcu2;

  model PsdEcu3 "Power Split hybrid power train controller, using ON/OFF strategy"
    extends Partial.PartialEcu;
    parameter Real socRef = 0.6 "Reference soc";
    parameter Real maxTorqueReq = 80 "Maximum torque that can be requested from mot";
    parameter Real powFiltT = 60 "Power filter time constant (s)";
    parameter Real socLoopGain = 50e3 "gain of the soc loop (w/pu)";
    parameter Real onThreshold = 7000 "average power over which engine is switched on (W)";
    parameter Real offThreshold = 5000 "average power below which engine is switched off (W)";
    Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = offThreshold, uHigh = onThreshold) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-34, 54})));
    Modelica.Blocks.Logical.Switch switch annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {6, 22})));
    Modelica.Blocks.Math.Add add annotation(
      Placement(visible = true, transformation(origin = {20, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.Constant socRef_(k = socRef) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-86, -42})));
    Modelica.Blocks.Math.Feedback fbSOC annotation(
      Placement(transformation(extent = {{-82, -2}, {-62, -22}})));
    Modelica.Blocks.Math.Gain socErrToPow(k = socLoopGain) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-42, -12})));
    Modelica.Blocks.Sources.Constant constZero(k = 0) annotation(
      Placement(transformation(extent = {{-34, 8}, {-22, 20}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y = add.y) annotation(
      Placement(transformation(extent = {{-68, 26}, {-48, 46}})));
    Modelica.Blocks.Sources.RealExpression realExpression1(y = switch.y) annotation(
      Placement(transformation(extent = {{-44, -68}, {-24, -48}})));
  equation
    connect(hysteresis.y, conn.iceON) annotation(
      Line(points = {{-34, 65}, {-34, 80}, {0, 80}}, color = {255, 0, 255}),
      Text(string = "%second", index = 1, extent = {{-3, 6}, {-3, 6}}, horizontalAlignment = TextAlignment.Right));
    connect(switch.y, conn.icePowRef) annotation(
      Line(points = {{17, 22}, {42, 22}, {42, 80}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}, horizontalAlignment = TextAlignment.Left));
    connect(hysteresis.y, switch.u2) annotation(
      Line(points = {{-34, 65}, {-34, 72}, {-16, 72}, {-16, 22}, {-6, 22}}, color = {255, 0, 255}));
    connect(powFilt.y, add.u1) annotation(
      Line(points = {{26, 39}, {26, -8}}, color = {0, 0, 127}));
    connect(socErrToPow.y, add.u2) annotation(
      Line(points = {{-31, -12}, {-8, -12}, {-8, -8}, {14, -8}}, color = {0, 0, 127}));
    connect(fbSOC.y, socErrToPow.u) annotation(
      Line(points = {{-63, -12}, {-54, -12}}, color = {0, 0, 127}));
    connect(fbSOC.u1, socRef_.y) annotation(
      Line(points = {{-80, -12}, {-86, -12}, {-86, -31}}, color = {0, 0, 127}));
    connect(fbSOC.u2, conn.batSOC) annotation(
      Line(points = {{-72, -4}, {-72, 80}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-3, 6}, {-3, 6}}, horizontalAlignment = TextAlignment.Right));
    connect(constZero.y, switch.u3) annotation(
      Line(points = {{-21.4, 14}, {-6, 14}}, color = {0, 0, 127}));
    connect(realExpression.y, hysteresis.u) annotation(
      Line(points = {{-47, 36}, {-34, 36}, {-34, 42}}, color = {0, 0, 127}));
    connect(realExpression1.y, powToWref.u) annotation(
      Line(points = {{-23, -58}, {-10, -58}}, color = {0, 0, 127}));
    connect(hysteresis.u, switch.u1) annotation(
      Line(points = {{-34, 42}, {-34, 30}, {-6, 30}}, color = {0, 0, 127}));
    annotation(
      Icon(graphics = {Text(extent = {{-100, 86}, {100, 56}}, textString = "PSD-ecu3", textColor = {0, 0, 0})}));
  end PsdEcu3;

  model ShevEMS "Ice, Generator, DriveTrain, all map-based"
    //€
    parameter Real tauPowFilt = 300 "power filter time constant";
    parameter Real powLow = 3000 "hysteresis control lower limit";
    parameter Real powHigh = 5000 "hysteresis control higher limit";
    parameter Real powPerSoc = 100e3 "SOC loop gain";
    parameter Real powMax = 100e3 "Max power that can be requested as output";
    parameter Real socRef = 0.7;
    Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = powMax) annotation(
      Placement(visible = true, transformation(origin = {12, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.Feedback fbSOC annotation(
      Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant socRef_(k = socRef) annotation(
      Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
    Modelica.Blocks.Math.Gain socErrToPow(k = powPerSoc) annotation(
      Placement(visible = true, transformation(origin = {-40, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Math.Add add annotation(
      Placement(visible = true, transformation(origin = {-18, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput edPow annotation(
      Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput soc annotation(
      Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Logical.Switch powSwitch annotation(
      Placement(visible = true, transformation(origin = {64, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Logical.Hysteresis powHyst(uHigh = powHigh, uLow = powLow) annotation(
      Placement(visible = true, transformation(origin = {50, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant zero(k = 0.0) annotation(
      Placement(visible = true, transformation(origin = {26, -48}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
    Modelica.Blocks.Interfaces.BooleanOutput on annotation(
      Placement(visible = true, transformation(extent = {{100, 30}, {120, 50}}, rotation = 0), iconTransformation(extent = {{98, 50}, {118, 70}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput pcPowReq annotation(
      Placement(visible = true, transformation(extent = {{100, -50}, {120, -30}}, rotation = 0), iconTransformation(extent = {{98, -70}, {118, -50}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder powFilt(y_start = 20e3, T = tauPowFilt) annotation(
      Placement(transformation(extent = {{-72, 44}, {-56, 60}})));
  equation
    connect(powSwitch.u1, limiter.y) annotation(
      Line(points = {{52, -12}, {30, -12}, {30, 46}, {23, 46}}, color = {0, 0, 127}));
    connect(powSwitch.u3, zero.y) annotation(
      Line(points = {{52, -28}, {44, -28}, {44, -48}, {37, -48}}, color = {0, 0, 127}));
    connect(powHyst.u, limiter.y) annotation(
      Line(points = {{38, 46}, {23, 46}}, color = {0, 0, 127}));
    connect(socErrToPow.y, add.u2) annotation(
      Line(points = {{-40, 33}, {-40, 40}, {-30, 40}}, color = {0, 0, 127}));
    connect(limiter.u, add.y) annotation(
      Line(points = {{0, 46}, {0, 46}, {-7, 46}}, color = {0, 0, 127}));
    connect(socErrToPow.u, fbSOC.y) annotation(
      Line(points = {{-40, 10}, {-40, 0}, {-51, 0}}, color = {0, 0, 127}));
    connect(fbSOC.u2, soc) annotation(
      Line(points = {{-60, -8}, {-60, -40}, {-120, -40}}, color = {0, 0, 127}));
    connect(socRef_.y, fbSOC.u1) annotation(
      Line(points = {{-79, -1.33227e-015}, {-76, -1.33227e-015}, {-76, 0}, {-74, 0}, {-68, 0}}, color = {0, 0, 127}));
    connect(powSwitch.u2, on) annotation(
      Line(points = {{52, -20}, {40, -20}, {26, -20}, {26, 22}, {88, 22}, {88, 40}, {110, 40}}, color = {255, 0, 255}));
    connect(powSwitch.y, pcPowReq) annotation(
      Line(points = {{75, -20}, {84, -20}, {84, -40}, {110, -40}}, color = {0, 0, 127}));
    connect(powFilt.y, add.u1) annotation(
      Line(points = {{-55.2, 52}, {-44, 52}, {-30, 52}}, color = {0, 0, 127}));
    connect(powFilt.u, edPow) annotation(
      Line(points = {{-73.6, 52}, {-78, 52}, {-78, 40}, {-120, 40}}, color = {0, 0, 127}));
    connect(powHyst.y, on) annotation(
      Line(points = {{61, 46}, {88, 46}, {88, 40}, {110, 40}}, color = {255, 0, 255}));
    annotation(
      Placement(visible = true, transformation(origin = {-58, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)),
      Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}})),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(lineColor = {95, 95, 95}, fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, points = {{-4, -40}, {74, 16}, {74, -6}, {-4, -62}, {-4, -40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{8, -38}, {28, -48}, {20, -54}, {0, -44}, {8, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{20, -54}, {28, -48}, {32, -56}, {24, -62}, {20, -54}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{24, -62}, {32, -56}, {32, -78}, {24, -84}, {24, -62}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{0, -44}, {20, -54}, {24, -62}, {24, -84}, {22, -84}, {22, -62}, {20, -58}, {0, -48}, {0, -44}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-14, 40}, {-18, 32}, {-10, 38}, {-8, 44}, {-14, 40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-18, 32}, {-10, 38}, {-10, 14}, {-18, 8}, {-18, 32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-20, 10}, {-20, 32}, {-16, 40}, {4, 30}, {4, 26}, {-16, 36}, {-18, 32}, {-18, 8}, {-20, 10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-8, 46}, {12, 36}, {4, 30}, {-16, 40}, {-8, 46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{28, -22}, {48, -32}, {40, -38}, {20, -28}, {28, -22}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{40, -38}, {48, -32}, {52, -40}, {44, -46}, {40, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{44, -46}, {52, -40}, {52, -62}, {44, -68}, {44, -46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{20, -28}, {40, -38}, {44, -46}, {44, -68}, {42, -68}, {42, -46}, {40, -42}, {20, -32}, {20, -28}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{48, -8}, {68, -18}, {60, -24}, {40, -14}, {48, -8}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{60, -24}, {68, -18}, {72, -26}, {64, -32}, {60, -24}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{64, -32}, {72, -26}, {72, -48}, {64, -54}, {64, -32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{40, -14}, {60, -24}, {64, -32}, {64, -54}, {62, -54}, {62, -32}, {60, -28}, {40, -18}, {40, -14}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{68, 6}, {88, -4}, {80, -10}, {60, 0}, {68, 6}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{80, -10}, {88, -4}, {92, -12}, {84, -18}, {80, -10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{84, -18}, {92, -12}, {92, -34}, {84, -40}, {84, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{60, 0}, {80, -10}, {84, -18}, {84, -40}, {82, -40}, {82, -18}, {80, -14}, {60, -4}, {60, 0}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-34, 26}, {-38, 18}, {-30, 24}, {-28, 30}, {-34, 26}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-38, 18}, {-30, 24}, {-30, 0}, {-38, -6}, {-38, 18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-40, -4}, {-40, 18}, {-36, 26}, {-16, 16}, {-16, 12}, {-36, 22}, {-38, 18}, {-38, -6}, {-40, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-28, 32}, {-8, 22}, {-16, 16}, {-36, 26}, {-28, 32}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-54, 12}, {-58, 4}, {-50, 10}, {-48, 16}, {-54, 12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-58, 4}, {-50, 10}, {-50, -14}, {-58, -20}, {-58, 4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-60, -18}, {-60, 4}, {-56, 12}, {-36, 2}, {-36, -2}, {-56, 8}, {-58, 4}, {-58, -20}, {-60, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-48, 18}, {-28, 8}, {-36, 2}, {-56, 12}, {-48, 18}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-74, -4}, {-78, -12}, {-70, -6}, {-68, 0}, {-74, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-78, -12}, {-70, -6}, {-70, -30}, {-78, -36}, {-78, -12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-80, -34}, {-80, -12}, {-76, -4}, {-56, -14}, {-56, -18}, {-76, -8}, {-78, -12}, {-78, -36}, {-80, -34}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-68, 2}, {-48, -8}, {-56, -14}, {-76, -4}, {-68, 2}}), Polygon(lineColor = {95, 95, 95}, fillColor = {75, 75, 75}, fillPattern = FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {-4, -62}, {-64, -30}, {-64, -8}}), Polygon(lineColor = {95, 95, 95}, fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {74, 16}, {14, 48}, {-64, -8}}), Rectangle(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-98, 92}, {98, 62}}), Text(origin = {-6.08518, -4.3529}, lineColor = {0, 0, 255}, extent = {{-91.9148, 98.3529}, {100.085, 60.353}}, fontName = "Helvetica", textString = "Shev Ems"), Text(lineColor = {0, 0, 255}, extent = {{-102, -102}, {98, -140}}, textString = "%name")}),
      experimentSetupOutput(derivatives = false),
      Documentation(info = "<html>
<p>SHEV logic. Contains:</p>
<p>- basic logic, which requests the average load power from the ICE</p>
<p>- additional SOC loop to avoid SOC drift</p>
<p>- further ON/OFF control to switch OFF the engine when the average power is too low to permit efficient operation</p>
</html>"),
      __OpenModelica_commandLineOptions = "");
  end ShevEMS;

  model GMS "Genset Management System (simplified)"
    parameter Real throttlePerWerr = 0.01 "speed controller gain (throttle per rad/s)";
    parameter Boolean optiSpeedOnFile = true;
    parameter Boolean tauLimitsOnFile = true;
    /*annotation(choices(checkBox = true))*/
    parameter String mapsFileName = "maps.txt" "File name where optimal speed is stored";
    import Modelica.Constants.pi;
    parameter Real os_uFactor = 1 "Factor before inputting pRef into map from txt file" annotation(
      Dialog(group = "GMS parameters", enable = optiSpeedOnFile));
    parameter Real os_yFactor = 2*pi/60 "Factor after reading optiSpeed from txt file" annotation(
      Dialog(group = "GMS parameters", enable = optiSpeedOnFile));
    parameter Real mt_uFactor = 1 "Factor before inputting wMecc into maxTau map from txt file" annotation(
      Dialog(group = "GMS parameters", enable = tauLimitsOnFile));
    parameter Real mt_yFactor = 1 "Factor after reading max torque from maxTau map from txt file" annotation(
      Dialog(group = "GMS parameters", enable = tauLimitsOnFile));
    parameter Real osTable[:, :] = [0, 100; 1000, 100] "optimal speed (rad/s) as a function of requested power (W)" annotation(
      Dialog(enable = not optiSpeedOnFile));
    parameter String osTableName = "optiSpeed";
    parameter Real mtTable[:, :] = [0, 100; 100, 100] "max torque  (Nm) as a function of speed  (rad/s))" annotation(
      Dialog(enable = not tauLimitsOnFile));
    parameter String mtTableName = "maxIceTau";
    Modelica.Blocks.Math.Division division annotation(
      Placement(transformation(origin = {-62, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Interfaces.RealInput pRef annotation(
      Placement(transformation(extent = {{-134, -20}, {-94, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
    Modelica.Blocks.Interfaces.RealOutput tRef "Torque request (positive when ICE delivers power)" annotation(
      Placement(transformation(origin = {0, -14}, extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
    Modelica.Blocks.Math.Feedback feedback annotation(
      Placement(transformation(extent = {{24, -40}, {44, -20}})));
    SupportModels.Miscellaneous.Gain gain(k = throttlePerWerr) annotation(
      Placement(transformation(extent = {{66, -40}, {86, -20}})));
    Modelica.Blocks.Nonlinear.VariableLimiter tauLimiter annotation(
      Placement(transformation(origin = {10, -14}, extent = {{62, 50}, {82, 70}})));
    Modelica.Blocks.Interfaces.RealOutput throttle annotation(
      Placement(transformation(extent = {{100, -40}, {120, -20}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
    Modelica.Blocks.Interfaces.RealInput Wmecc annotation(
      Placement(transformation(origin = {-8, -88}, extent = {{-14, -14}, {14, 14}}, rotation = 90), iconTransformation(origin = {-1, -115}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
    SupportModels.MapBasedRelated.CombiTable1Factor optiSpeed(uFactor = os_uFactor, yFactor = os_yFactor, tableOnFile = mapsOnFile, table = osTable, tableName = osTableName, fileName = mapsFileName) annotation(
      Placement(transformation(origin = {-42, -30}, extent = {{-10, -10}, {10, 10}})));
    SupportModels.MapBasedRelated.CombiTable1Factor maxTau(fileName = mapsFileName, table = mtTable, tableName = mtTableName, tableOnFile = mapsOnFile, uFactor = mt_uFactor, yFactor = mt_yFactor) annotation(
      Placement(transformation(origin = {12, 62}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
      Placement(transformation(origin = {48, 32}, extent = {{-8, -8}, {8, 8}})));
  equation
    connect(throttle, gain.y) annotation(
      Line(points = {{110, -30}, {87, -30}}, color = {0, 0, 127}));
    connect(feedback.y, gain.u) annotation(
      Line(points = {{43, -30}, {64, -30}}, color = {0, 0, 127}));
    connect(tauLimiter.y, tRef) annotation(
      Line(points = {{93, 46}, {110, 46}}, color = {0, 0, 127}));
    connect(division.y, tauLimiter.u) annotation(
      Line(points = {{-62, 41}, {-62, 46}, {70, 46}}, color = {0, 0, 127}));
    connect(division.u2, Wmecc) annotation(
      Line(points = {{-56, 18}, {-56, 0}, {-8, 0}, {-8, -88}}, color = {0, 0, 127}));
    connect(division.u1, optiSpeed.u) annotation(
      Line(points = {{-68, 18}, {-68, -30}, {-54, -30}}, color = {0, 0, 127}));
    connect(pRef, division.u1) annotation(
      Line(points = {{-114, 0}, {-68, 0}, {-68, 18}}, color = {0, 0, 127}));
    connect(maxTau.u, Wmecc) annotation(
      Line(points = {{0, 62}, {-8, 62}, {-8, -88}}, color = {0, 0, 127}));
    connect(tauLimiter.limit2, gain1.y) annotation(
      Line(points = {{70, 38}, {64, 38}, {64, 32}, {56.8, 32}}, color = {0, 0, 127}));
    connect(feedback.u1, optiSpeed.y[1]) annotation(
      Line(points = {{26, -30}, {20, -30}, {20, -28}, {-31, -28}, {-31, -30}}, color = {0, 0, 127}));
    connect(tauLimiter.limit1, maxTau.y[1]) annotation(
      Line(points = {{70, 54}, {38, 54}, {38, 62}, {23, 62}}, color = {0, 0, 127}));
    connect(tauLimiter.limit1, gain1.u) annotation(
      Line(points = {{70, 54}, {38, 54}, {38, 62}, {32, 62}, {32, 34}, {36, 34}, {36, 32}, {38.4, 32}}, color = {0, 0, 127}));
  connect(feedback.u2, Wmecc) annotation(
      Line(points = {{34, -38}, {34, -88}, {-8, -88}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -90}, {100, 80}})),
      experimentSetupOutput,
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-98, 22}, {98, -16}}, textString = "%name")}),
      Documentation(info = "<html><head></head><body><p>Genset Management System.</p>
<p>The control logic commands the genset to deliver at the DC port the input power, using the optimal generator speed. ICE torque tRef is controlled through the generator.</p><p>Table maxTau, intended for defining maximum ICE torque, actually limits the generator electromechanical torque: there is a small approximation in this, since during transients generator inertia causes the two to be slightly different from each other.</p>
</body></html>"));
  end GMS;

  model GMSold "Genset Management System (simplified)"
    parameter Real throttlePerWerr = 0.01 "speed controller gain (throttle per rad/s)";
    parameter String mapsFileName = "maps.txt" "File name where optimal speed is stored";
    import Modelica.Constants.pi;
    parameter Modelica.Units.SI.Torque nomTorque = 1 "Torque multiplier for efficiency map torques";
    parameter Modelica.Units.SI.AngularVelocity nomSpeed = 1 "Speed multiplier for efficiency map speeds";
    Modelica.Blocks.Tables.CombiTable1Dv optiSpeed(tableOnFile = true, columns = {2}, tableName = "optiSpeed", fileName = mapsFileName, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) "gives the optimal speed as a function of requested power" annotation(
      Placement(transformation(extent = {{-80, -40}, {-60, -20}})));
    Modelica.Blocks.Math.Division division annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-62, 44})));
    Modelica.Blocks.Interfaces.RealInput pRef annotation(
      Placement(transformation(extent = {{-134, -20}, {-94, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
    Modelica.Blocks.Interfaces.RealOutput tRef "Torque request (positive when ICE delivers power)" annotation(
      Placement(transformation(extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
    Modelica.Blocks.Math.Feedback feedback annotation(
      Placement(transformation(extent = {{24, -40}, {44, -20}})));
    SupportModels.Miscellaneous.Gain gain(k = throttlePerWerr) annotation(
      Placement(transformation(extent = {{66, -40}, {86, -20}})));
    Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {34, -60})));
    Modelica.Blocks.Tables.CombiTable1Dv maxTau(columns = {2}, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, fileName = mapsFileName, tableName = "maxIceTau", tableOnFile = true) "Gives the maximum torque as a function of the mechanical speed" annotation(
      Placement(transformation(extent = {{-12, 68}, {8, 88}})));
    Modelica.Blocks.Nonlinear.VariableLimiter tauLimiter annotation(
      Placement(transformation(extent = {{62, 50}, {82, 70}})));
    Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
      Placement(transformation(extent = {{-8, -8}, {8, 8}}, rotation = 90, origin = {52, 40})));
    SupportModels.Miscellaneous.Gain fromPuTorque(k = nomTorque) annotation(
      Placement(visible = true, transformation(origin = {25, 77}, extent = {{7, -7}, {-7, 7}}, rotation = 180)));
    SupportModels.Miscellaneous.Gain toPuSpeed(k = 1/nomSpeed) annotation(
      Placement(visible = true, transformation(origin = {-27, 31}, extent = {{7, -7}, {-7, 7}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealOutput throttle annotation(
      Placement(transformation(extent = {{100, -40}, {120, -20}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
    Modelica.Blocks.Interfaces.RealInput Wmecc annotation(
      Placement(transformation(extent = {{-14, -14}, {14, 14}}, rotation = 90, origin = {0, -98}), iconTransformation(extent = {{-15, -15}, {15, 15}}, rotation = 90, origin = {-1, -115})));
  equation
    connect(division.u1, optiSpeed.u[1]) annotation(
      Line(points = {{-68, 32}, {-68, 10}, {-86, 10}, {-86, -30}, {-82, -30}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(optiSpeed.u[1], pRef) annotation(
      Line(points = {{-82, -30}, {-86, -30}, {-86, 0}, {-114, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(throttle, gain.y) annotation(
      Line(points = {{110, -30}, {87, -30}}, color = {0, 0, 127}));
    connect(feedback.y, gain.u) annotation(
      Line(points = {{43, -30}, {64, -30}}, color = {0, 0, 127}));
    connect(to_rpm.y, feedback.u2) annotation(
      Line(points = {{34, -49}, {34, -38}}, color = {0, 0, 127}));
    connect(tauLimiter.y, tRef) annotation(
      Line(points = {{83, 60}, {110, 60}}, color = {0, 0, 127}));
    connect(division.y, tauLimiter.u) annotation(
      Line(points = {{-62, 55}, {-62, 60}, {60, 60}}, color = {0, 0, 127}));
    connect(gain1.y, tauLimiter.limit2) annotation(
      Line(points = {{52, 48.8}, {52, 52}, {60, 52}}, color = {0, 0, 127}));
    connect(tauLimiter.limit1, fromPuTorque.y) annotation(
      Line(points = {{60, 68}, {46, 68}, {46, 77}, {32.7, 77}}, color = {0, 0, 127}));
    connect(fromPuTorque.u, maxTau.y[1]) annotation(
      Line(points = {{16.6, 77}, {16.6, 78}, {9, 78}}, color = {0, 0, 127}));
    connect(maxTau.u[1], toPuSpeed.y) annotation(
      Line(points = {{-14, 78}, {-27, 78}, {-27, 38.7}}, color = {0, 0, 127}));
    connect(toPuSpeed.u, Wmecc) annotation(
      Line(points = {{-27, 22.6}, {-27, 12}, {0, 12}, {0, -98}}, color = {0, 0, 127}));
    connect(gain1.u, fromPuTorque.y) annotation(
      Line(points = {{52, 30.4}, {52, 26}, {34, 26}, {34, 77}, {32.7, 77}}, color = {0, 0, 127}));
    connect(division.u2, Wmecc) annotation(
      Line(points = {{-56, 32}, {-56, 0}, {0, 0}, {0, -98}}, color = {0, 0, 127}));
    connect(to_rpm.u, Wmecc) annotation(
      Line(points = {{34, -72}, {34, -78}, {0, -78}, {0, -98}}, color = {0, 0, 127}));
    connect(feedback.u1, optiSpeed.y[1]) annotation(
      Line(points = {{26, -30}, {-59, -30}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -90}, {100, 100}}), graphics = {Text(extent = {{-12, 36}, {8, 22}}, textColor = {28, 108, 200}, textString = "constant=1 for 
  un-normalised
  speeds", horizontalAlignment = TextAlignment.Left), Text(extent = {{4, 60}, {24, 46}}, textColor = {28, 108, 200}, horizontalAlignment = TextAlignment.Left, textString = "constant=1 for 
  un-normalised
  torques")}),
      experimentSetupOutput,
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-98, 22}, {98, -16}}, textString = "%name")}),
      Documentation(info = "<html><head></head><body><p>Genset Management System.</p>
  <p>The control logic commands the genset to deliver at the DC port the input power, using the optimal generator speed.</p><p>Max ICE torque is actually controlled, and limited, through the generator torque (with the approximation that it is limited beyond the intertia interla to the generator)</p>
  </body></html>"));
  end GMSold;

  package Partial
    partial model PartialGMS "Genset Management System (simplified)"
      parameter Real throttlePerWerr = 0.01 "speed controller gain (throttle per rad/s)";
      parameter String mapsFileName = "maps.txt" "File name where optimal speed is stored";
      import Modelica.Constants.pi;
      parameter Modelica.Units.SI.Torque nomTorque = 1 "Torque multiplier for efficiency map torques";
      parameter Modelica.Units.SI.AngularVelocity nomSpeed = 1 "Speed multiplier for efficiency map speeds";
      Modelica.Blocks.Tables.CombiTable1Dv optiSpeed(tableOnFile = true, columns = {2}, tableName = "optiSpeed", fileName = mapsFileName, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) "gives the optimal speed as a function of requested power" annotation(
        Placement(transformation(extent = {{-80, -40}, {-60, -20}})));
      Modelica.Blocks.Math.Division division annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-62, 44})));
      Modelica.Blocks.Interfaces.RealInput pRef annotation(
        Placement(transformation(extent = {{-134, -20}, {-94, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
      Modelica.Blocks.Interfaces.RealOutput tRef "Torque request (positive when ICE delivers power)" annotation(
        Placement(transformation(extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
      Modelica.Blocks.Math.Feedback feedback annotation(
        Placement(transformation(extent = {{24, -40}, {44, -20}})));
      SupportModels.Miscellaneous.Gain gain(k = throttlePerWerr) annotation(
        Placement(transformation(extent = {{66, -40}, {86, -20}})));
      Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {34, -60})));
      Modelica.Blocks.Tables.CombiTable1Dv maxTau(columns = {2}, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, fileName = mapsFileName, tableName = "maxIceTau", tableOnFile = true) "gives the optimal speed as a function of requested power" annotation(
        Placement(transformation(extent = {{-12, 68}, {8, 88}})));
      Modelica.Blocks.Nonlinear.VariableLimiter tauLimiter annotation(
        Placement(transformation(extent = {{62, 50}, {82, 70}})));
      Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
        Placement(transformation(extent = {{-8, -8}, {8, 8}}, rotation = 90, origin = {52, 40})));
      SupportModels.Miscellaneous.Gain fromPuTorque(k = nomTorque) annotation(
        Placement(visible = true, transformation(origin = {25, 77}, extent = {{7, -7}, {-7, 7}}, rotation = 180)));
      SupportModels.Miscellaneous.Gain toPuSpeed(k = 1/nomSpeed) annotation(
        Placement(visible = true, transformation(origin = {-27, 31}, extent = {{7, -7}, {-7, 7}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput throttle annotation(
        Placement(transformation(extent = {{100, -40}, {120, -20}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
      Modelica.Blocks.Interfaces.RealInput Wmecc annotation(
        Placement(transformation(extent = {{-14, -14}, {14, 14}}, rotation = 90, origin = {0, -98}), iconTransformation(extent = {{-15, -15}, {15, 15}}, rotation = 90, origin = {-1, -115})));
    equation
      connect(division.u1, optiSpeed.u[1]) annotation(
        Line(points = {{-68, 32}, {-68, 10}, {-86, 10}, {-86, -30}, {-82, -30}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(optiSpeed.u[1], pRef) annotation(
        Line(points = {{-82, -30}, {-86, -30}, {-86, 0}, {-114, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(throttle, gain.y) annotation(
        Line(points = {{110, -30}, {87, -30}}, color = {0, 0, 127}));
      connect(feedback.y, gain.u) annotation(
        Line(points = {{43, -30}, {64, -30}}, color = {0, 0, 127}));
      connect(to_rpm.y, feedback.u2) annotation(
        Line(points = {{34, -49}, {34, -38}}, color = {0, 0, 127}));
      connect(tauLimiter.y, tRef) annotation(
        Line(points = {{83, 60}, {110, 60}}, color = {0, 0, 127}));
      connect(division.y, tauLimiter.u) annotation(
        Line(points = {{-62, 55}, {-62, 60}, {60, 60}}, color = {0, 0, 127}));
      connect(gain1.y, tauLimiter.limit2) annotation(
        Line(points = {{52, 48.8}, {52, 52}, {60, 52}}, color = {0, 0, 127}));
      connect(tauLimiter.limit1, fromPuTorque.y) annotation(
        Line(points = {{60, 68}, {46, 68}, {46, 77}, {32.7, 77}}, color = {0, 0, 127}));
      connect(fromPuTorque.u, maxTau.y[1]) annotation(
        Line(points = {{16.6, 77}, {16.6, 78}, {9, 78}}, color = {0, 0, 127}));
      connect(maxTau.u[1], toPuSpeed.y) annotation(
        Line(points = {{-14, 78}, {-27, 78}, {-27, 38.7}}, color = {0, 0, 127}));
      connect(toPuSpeed.u, Wmecc) annotation(
        Line(points = {{-27, 22.6}, {-27, 12}, {0, 12}, {0, -98}}, color = {0, 0, 127}));
      connect(gain1.u, fromPuTorque.y) annotation(
        Line(points = {{52, 30.4}, {52, 26}, {34, 26}, {34, 77}, {32.7, 77}}, color = {0, 0, 127}));
      connect(division.u2, Wmecc) annotation(
        Line(points = {{-56, 32}, {-56, 0}, {0, 0}, {0, -98}}, color = {0, 0, 127}));
      connect(to_rpm.u, Wmecc) annotation(
        Line(points = {{34, -72}, {34, -78}, {0, -78}, {0, -98}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -90}, {100, 100}}), graphics = {Text(extent = {{-12, 36}, {8, 22}}, textColor = {28, 108, 200}, textString = "constant=1 for 
un-normalised
speeds", horizontalAlignment = TextAlignment.Left), Text(extent = {{4, 60}, {24, 46}}, textColor = {28, 108, 200}, horizontalAlignment = TextAlignment.Left, textString = "constant=1 for 
un-normalised
torques")}),
        experimentSetupOutput,
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-98, 22}, {98, -16}}, textString = "%name")}),
        Documentation(info = "<html>
<p>Genset Management System.</p>
<p>The control logic commands the genset to deliver at the DC port the input power, using the optimal generator speed.</p>
</html>"));
    end PartialGMS;

    partial model PartialEcu "Power Split hybrid power train controller, not using ON/OFF strategy"
      parameter Real genTorqueMax = 80 "maximum absolute value of gen torque (Nm)";
      parameter Real maxTorqueReq = 80 "Torque request (Nm) that corresponds to 1 from driver";
      parameter Real powFiltT = 60 "Power filter time constant (s)";
      parameter Real genLoopGain = 0.1 "Control gain between ice speed error and gen torque: Nm/(rad/s)";
      Modelica.Blocks.Continuous.FirstOrder powFilt(T = powFiltT, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
        Placement(visible = true, transformation(origin = {26, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      SupportModels.ConnectorRelated.Conn conn annotation(
        Placement(visible = true, transformation(extent = {{-20, 60}, {20, 100}}, rotation = 0), iconTransformation(extent = {{-20, 78}, {20, 118}}, rotation = 0)));
      Modelica.Blocks.Math.Gain gain(k = genLoopGain) annotation(
        Placement(visible = true, transformation(extent = {{78, -68}, {98, -48}}, rotation = 0)));
      Modelica.Blocks.Math.Feedback feedback annotation(
        Placement(visible = true, transformation(extent = {{50, -48}, {70, -68}}, rotation = 0)));
      Modelica.Blocks.Nonlinear.Limiter limiter(uMax = genTorqueMax, uMin = -genTorqueMax) annotation(
        Placement(visible = true, transformation(origin = {98, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Tables.CombiTable1Ds powToWref(fileName = "wToTau.txt", tableOnFile = false, table = [0, 0; 1884, 126; 9800, 126; 36600, 366; 52300, 523]) "optimal ice speed as a function of power" annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {2, -58})));
      Modelica.Blocks.Math.Gain toNm(k = maxTorqueReq) "converts p.u. torque request into Nm" annotation(
        Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-108, 32})));
      Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e6, uMin = 125) annotation(
        Placement(visible = true, transformation(origin = {32, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.FirstOrder genTauFilt(T = 1, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
        Placement(visible = true, transformation(origin = {98, 12}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput tauRef annotation(
        Placement(visible = true, transformation(extent = {{-158, -20}, {-118, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
    equation
      connect(powFilt.u, conn.motPowDelB) annotation(
        Line(points = {{26, 62}, {26, 70}, {0, 70}, {0, 80}}, color = {0, 0, 127}));
      connect(gain.u, feedback.y) annotation(
        Line(points = {{76, -58}, {69, -58}}, color = {0, 0, 127}));
      connect(feedback.u2, conn.iceW) annotation(
        Line(points = {{60, -50}, {60, 76}, {0, 76}, {0, 80}}, color = {0, 0, 127}, smooth = Smooth.None),
        Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
      connect(limiter.y, conn.genTauRef) annotation(
        Line(points = {{98, 51}, {98, 78}, {0, 78}, {0, 80}}, color = {0, 0, 127}, smooth = Smooth.None),
        Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
      connect(toNm.u, tauRef) annotation(
        Line(points = {{-108, 20}, {-108, 0}, {-138, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(toNm.y, conn.motTauRef) annotation(
        Line(points = {{-108, 43}, {-108, 80}, {0, 80}}, color = {0, 0, 127}, smooth = Smooth.None),
        Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
      connect(feedback.u1, limiter1.y) annotation(
        Line(points = {{52, -58}, {43, -58}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(limiter1.u, powToWref.y[1]) annotation(
        Line(points = {{20, -58}, {13, -58}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(limiter.u, genTauFilt.y) annotation(
        Line(points = {{98, 28}, {98, 23}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(genTauFilt.u, gain.y) annotation(
        Line(points = {{98, 0}, {98, -58}, {99, -58}}, color = {0, 0, 127}, smooth = Smooth.None));
      annotation(
        Diagram(coordinateSystem(extent = {{-120, -80}, {120, 80}}, preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(extent = {{28, 62}, {68, 58}}, textColor = {0, 0, 0}, textString = "send
PowRef
to ice"), Text(extent = {{100, 70}, {132, 60}}, textString = "send 
reference tau
to gen", horizontalAlignment = TextAlignment.Left), Line(origin = {48, 50}, points = {{0, 6}, {0, -6}, {0, -6}}, arrow = {Arrow.Filled, Arrow.None}), Line(origin = {64, 52}, points = {{0, -6}, {0, 6}, {0, 6}}, arrow = {Arrow.Filled, Arrow.None}), Line(origin = {94, 66}, points = {{0, 6}, {0, -6}, {0, -6}}, arrow = {Arrow.Filled, Arrow.None}), Text(extent = {{-106, 74}, {-92, 62}}, textString = "Send 
requested
torque 
to mot", horizontalAlignment = TextAlignment.Left)}),
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-100, -102}, {100, -140}}, textString = "%name"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(lineColor = {95, 95, 95}, fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, points = {{-4, -40}, {74, 16}, {74, -6}, {-4, -62}, {-4, -40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{8, -38}, {28, -48}, {20, -54}, {0, -44}, {8, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{20, -54}, {28, -48}, {32, -56}, {24, -62}, {20, -54}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{24, -62}, {32, -56}, {32, -78}, {24, -84}, {24, -62}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{0, -44}, {20, -54}, {24, -62}, {24, -84}, {22, -84}, {22, -62}, {20, -58}, {0, -48}, {0, -44}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-14, 40}, {-18, 32}, {-10, 38}, {-8, 44}, {-14, 40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-18, 32}, {-10, 38}, {-10, 14}, {-18, 8}, {-18, 32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-20, 10}, {-20, 32}, {-16, 40}, {4, 30}, {4, 26}, {-16, 36}, {-18, 32}, {-18, 8}, {-20, 10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-8, 46}, {12, 36}, {4, 30}, {-16, 40}, {-8, 46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{28, -22}, {48, -32}, {40, -38}, {20, -28}, {28, -22}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{40, -38}, {48, -32}, {52, -40}, {44, -46}, {40, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{44, -46}, {52, -40}, {52, -62}, {44, -68}, {44, -46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{20, -28}, {40, -38}, {44, -46}, {44, -68}, {42, -68}, {42, -46}, {40, -42}, {20, -32}, {20, -28}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{48, -8}, {68, -18}, {60, -24}, {40, -14}, {48, -8}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{60, -24}, {68, -18}, {72, -26}, {64, -32}, {60, -24}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{64, -32}, {72, -26}, {72, -48}, {64, -54}, {64, -32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{40, -14}, {60, -24}, {64, -32}, {64, -54}, {62, -54}, {62, -32}, {60, -28}, {40, -18}, {40, -14}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{68, 6}, {88, -4}, {80, -10}, {60, 0}, {68, 6}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{80, -10}, {88, -4}, {92, -12}, {84, -18}, {80, -10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{84, -18}, {92, -12}, {92, -34}, {84, -40}, {84, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{60, 0}, {80, -10}, {84, -18}, {84, -40}, {82, -40}, {82, -18}, {80, -14}, {60, -4}, {60, 0}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-34, 26}, {-38, 18}, {-30, 24}, {-28, 30}, {-34, 26}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-38, 18}, {-30, 24}, {-30, 0}, {-38, -6}, {-38, 18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-40, -4}, {-40, 18}, {-36, 26}, {-16, 16}, {-16, 12}, {-36, 22}, {-38, 18}, {-38, -6}, {-40, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-28, 32}, {-8, 22}, {-16, 16}, {-36, 26}, {-28, 32}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-54, 12}, {-58, 4}, {-50, 10}, {-48, 16}, {-54, 12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-58, 4}, {-50, 10}, {-50, -14}, {-58, -20}, {-58, 4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-60, -18}, {-60, 4}, {-56, 12}, {-36, 2}, {-36, -2}, {-56, 8}, {-58, 4}, {-58, -20}, {-60, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-48, 18}, {-28, 8}, {-36, 2}, {-56, 12}, {-48, 18}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, points = {{-74, -4}, {-78, -12}, {-70, -6}, {-68, 0}, {-74, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, points = {{-78, -12}, {-70, -6}, {-70, -30}, {-78, -36}, {-78, -12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0}, fillPattern = FillPattern.Solid, points = {{-80, -34}, {-80, -12}, {-76, -4}, {-56, -14}, {-56, -18}, {-76, -8}, {-78, -12}, {-78, -36}, {-80, -34}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{-68, 2}, {-48, -8}, {-56, -14}, {-76, -4}, {-68, 2}}), Polygon(lineColor = {95, 95, 95}, fillColor = {75, 75, 75}, fillPattern = FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {-4, -62}, {-64, -30}, {-64, -8}}), Polygon(lineColor = {95, 95, 95}, fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {74, 16}, {14, 48}, {-64, -8}})}),
        Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Power Split Power Train Controller without ON/OFF</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This controller operates as follows:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">it makes the ice deliver the average power needed by the power train</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">it determines the optimal ice speed at which the requested power is delivered with minimum fuel consumption and asks the &quot;gen&quot; to control so that the ice operates at that speed</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">the vehicle motion is controlled acting on the &quot;mot&quot;.</span></li>
</ul>
<p>Since this technique allows only approximatively the correct energy balance of the vehicle, the battery tends to discharge.This is solved with Ecu2, in which a closed loop StateOfCharge (SOC) control is added.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">So:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">powFilt Block filters the delivered power to obtained the power to ask the ICE to deliver</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">toIceWref converts the power to be requested from the ICE by its maximum torque at the actual speed</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">after a limiting block, this torque is the reference signal of a feedback; the corresponding error controls the Gen torque.</span></li>
</ul>
</html>"));
    end PartialEcu;
  end Partial;
end ECUs;
