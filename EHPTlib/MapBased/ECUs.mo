within EHPTlib.MapBased;
package ECUs
  model Ecu1 "Power Split hybrid power train controller, not using ON/OFF strategy"
    parameter Real genTorqueMax = 80 "maximum absolute value of gen torque (Nm)";
    parameter Real maxTorqueReq = 80 "Torque request (Nm) that corresponds to 1 from driver";
    parameter Real powFiltT = 60 "Power filter time constant (s)";
    parameter Real genLoopGain = 0.1 "Control gain between ice speed error and gen torque: Nm/(rad/s)";
    Modelica.Blocks.Interfaces.RealInput tauRef annotation (
      Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder powFilt(T = powFiltT, initType=Modelica.Blocks.Types.Init.InitialOutput)
                                                                annotation (
      Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    SupportModels.ConnectorRelated.Conn conn1 annotation (
      Placement(visible = true, transformation(extent = {{-20, 60}, {20, 100}}, rotation = 0), iconTransformation(extent = {{-20, 78}, {20, 118}}, rotation = 0)));
    Modelica.Blocks.Math.Gain gain(k = genLoopGain) annotation (
      Placement(visible = true, transformation(extent = {{32, -30}, {52, -10}}, rotation = 0)));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(visible = true, transformation(extent = {{6, -10}, {26, -30}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMax = genTorqueMax, uMin = -genTorqueMax) annotation (
      Placement(visible = true, transformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Tables.CombiTable1Ds powToW(fileName = "wToTau.txt", tableOnFile = false,
    table = [0, 0; 1884, 126; 9800, 126; 36600, 366; 52300, 523]) "optimal ice speed as a function of power" annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-40, -20})));
    Modelica.Blocks.Math.Gain toNm(k = maxTorqueReq) "converts p.u. torque request into Nm" annotation (
      Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-80, 32})));
    Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e6, uMin = 125) annotation (
      Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder genTauFilt(T = 1, initType=Modelica.Blocks.Types.Init.InitialOutput)  annotation (
      Placement(visible = true, transformation(origin = {60, 12}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  equation
    connect(powFilt.u, conn1.motPowDelB) annotation (
      Line(points={{-40,52},{-40,64},{-10,64},{-10,76},{0,76},{0,80}},
                                                              color = {0, 0, 127}));
    connect(powFilt.y, conn1.icePowRef) annotation (
      Line(points={{-40,29},{-40,20},{-6,20},{-6,76},{0,76},{0,80}},
                                                              color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(gain.u, feedback.y) annotation (
      Line(points = {{30, -20}, {25, -20}}, color = {0, 0, 127}));
    connect(powToW.u, powFilt.y) annotation (
      Line(points = {{-52, -20}, {-60, -20}, {-60, 20}, {-40, 20}, {-40, 29}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(feedback.u2, conn1.iceW) annotation (
      Line(points = {{16, -12}, {16, 40}, {16, 40}, {16, 66}, {0, 66}, {0, 80}}, color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(limiter.y, conn1.genTauRef) annotation (
      Line(points={{60,51},{60,78},{0,78},{0,80}},          color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(toNm.u, tauRef) annotation (
      Line(points = {{-80, 20}, {-80, 0}, {-120, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toNm.y, conn1.motTauRef) annotation (
      Line(points = {{-80, 43}, {-80, 80}, {0, 80}}, color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(feedback.u1, limiter1.y) annotation (
      Line(points = {{8, -20}, {1, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(limiter1.u, powToW.y[1]) annotation (
      Line(points = {{-22, -20}, {-29, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(limiter.u, genTauFilt.y) annotation (
      Line(points = {{60, 28}, {60, 23}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(genTauFilt.u, gain.y) annotation (
      Line(points = {{60, 0}, {60, -20}, {53, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
    annotation (
      Diagram(coordinateSystem(extent = {{-100, -60}, {100, 80}}, preserveAspectRatio = false, initialScale = 0.1), graphics={  Text(extent = {{-82, 74}, {-24, 70}}, textString = "Send requested torque to mot"), Text(extent={{
                -38,16},{2,12}}, textString = "send filtered power\nto ice"),
                   Text(extent = {{62, 70}, {94, 60}}, textString = "send 
reference tau
to gen",
     horizontalAlignment = TextAlignment.Left), Line(origin = {-4, 42}, points={{0, 6},{0,-6},{0,-6}},                                                                          arrow = {Arrow.Filled, Arrow.None}),
            Line(origin={18,52},    points = {{0, -6}, {0, 6}, {0, 6}}, arrow = {Arrow.Filled, Arrow.None}),
            Line(origin={56,66},    points={{0,6},{0,-6},{0,-6}},                                                                          arrow = {Arrow.Filled, Arrow.None})}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false,
         initialScale = 0.1, grid = {2, 2}), graphics={  Text(lineColor = {0, 0, 255}, extent = {{-100, -102}, {100, -140}}, textString = "%name"), Rectangle(fillColor = {255, 255, 255},
         fillPattern =  FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(lineColor = {95, 95, 95}, fillColor = {175, 175, 175},
         fillPattern =  FillPattern.Solid, points = {{-4, -40}, {74, 16}, {74, -6}, {-4, -62}, {-4, -40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{8, -38}, {28, -48}, {20, -54}, {0, -44}, {8, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{20, -54}, {28, -48}, {32, -56}, {24, -62}, {20, -54}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{24, -62}, {32, -56}, {32, -78}, {24, -84}, {24, -62}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{0, -44}, {20, -54}, {24, -62}, {24, -84}, {22, -84}, {22, -62}, {20, -58}, {0, -48}, {0, -44}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
         fillPattern =  FillPattern.Solid, points = {{-14, 40}, {-18, 32}, {-10, 38}, {-8, 44}, {-14, 40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{-18, 32}, {-10, 38}, {-10, 14}, {-18, 8}, {-18, 32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{-20, 10}, {-20, 32}, {-16, 40}, {4, 30}, {4, 26}, {-16, 36}, {-18, 32}, {-18, 8}, {-20, 10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{-8, 46}, {12, 36}, {4, 30}, {-16, 40}, {-8, 46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{28, -22}, {48, -32}, {40, -38}, {20, -28}, {28, -22}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{40, -38}, {48, -32}, {52, -40}, {44, -46}, {40, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{44, -46}, {52, -40}, {52, -62}, {44, -68}, {44, -46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{20, -28}, {40, -38}, {44, -46}, {44, -68}, {42, -68}, {42, -46}, {40, -42}, {20, -32}, {20, -28}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{48, -8}, {68, -18}, {60, -24}, {40, -14}, {48, -8}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{60, -24}, {68, -18}, {72, -26}, {64, -32}, {60, -24}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{64, -32}, {72, -26}, {72, -48}, {64, -54}, {64, -32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{40, -14}, {60, -24}, {64, -32}, {64, -54}, {62, -54}, {62, -32}, {60, -28}, {40, -18}, {40, -14}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{68, 6}, {88, -4}, {80, -10}, {60, 0}, {68, 6}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{80, -10}, {88, -4}, {92, -12}, {84, -18}, {80, -10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{84, -18}, {92, -12}, {92, -34}, {84, -40}, {84, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{60, 0}, {80, -10}, {84, -18}, {84, -40}, {82, -40}, {82, -18}, {80, -14}, {60, -4}, {60, 0}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
         fillPattern =  FillPattern.Solid, points = {{-34, 26}, {-38, 18}, {-30, 24}, {-28, 30}, {-34, 26}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{-38, 18}, {-30, 24}, {-30, 0}, {-38, -6}, {-38, 18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{-40, -4}, {-40, 18}, {-36, 26}, {-16, 16}, {-16, 12}, {-36, 22}, {-38, 18}, {-38, -6}, {-40, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{-28, 32}, {-8, 22}, {-16, 16}, {-36, 26}, {-28, 32}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
         fillPattern =  FillPattern.Solid, points = {{-54, 12}, {-58, 4}, {-50, 10}, {-48, 16}, {-54, 12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{-58, 4}, {-50, 10}, {-50, -14}, {-58, -20}, {-58, 4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{-60, -18}, {-60, 4}, {-56, 12}, {-36, 2}, {-36, -2}, {-56, 8}, {-58, 4}, {-58, -20}, {-60, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{-48, 18}, {-28, 8}, {-36, 2}, {-56, 12}, {-48, 18}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
         fillPattern =  FillPattern.Solid, points = {{-74, -4}, {-78, -12}, {-70, -6}, {-68, 0}, {-74, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
         fillPattern =  FillPattern.Solid, points = {{-78, -12}, {-70, -6}, {-70, -30}, {-78, -36}, {-78, -12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
         fillPattern =  FillPattern.Solid, points = {{-80, -34}, {-80, -12}, {-76, -4}, {-56, -14}, {-56, -18}, {-76, -8}, {-78, -12}, {-78, -36}, {-80, -34}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
         fillPattern =  FillPattern.Solid, points = {{-68, 2}, {-48, -8}, {-56, -14}, {-76, -4}, {-68, 2}}), Polygon(lineColor = {95, 95, 95}, fillColor = {75, 75, 75},
         fillPattern =  FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {-4, -62}, {-64, -30}, {-64, -8}}), Polygon(lineColor = {95, 95, 95}, fillColor = {160, 160, 164},
         fillPattern =  FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {74, 16}, {14, 48}, {-64, -8}}), Rectangle(fillColor = {255, 255, 255}, pattern = LinePattern.None,
         fillPattern =  FillPattern.Solid, extent = {{-98, 92}, {98, 62}}), Text(extent = {{-100, 84}, {100, 54}}, textString = "PSD-ecu1")}),
      Documentation(info="<html>
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
  end Ecu1;

  model Ecu2 "Power Split hybrid power train controller, with SOC control, without ON/OFF"
    parameter Modelica.Units.SI.Torque genTorqueMax=80
      "maximum absolute valoe of gen torque";
    parameter Real socRef = 0.6 "Target value of SOC";
    parameter Modelica.Units.SI.Power socLoopGain=10000 "soc loop gain";
    parameter Modelica.Units.SI.Torque maxTorqueReq=80
      "Torque request (Nm) that corresponds to 1 from driver";
    parameter Real genLoopGain(unit = "N.m/(rad/s)") = 0.1 "Control gain between ICE speed error and gen torque";
    parameter Modelica.Units.SI.Time powFiltT=60
      "Power filter time constant (s)";
    Modelica.Blocks.Interfaces.RealInput tauReference annotation (
      Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder powFilt(T = powFiltT, initType=Modelica.Blocks.Types.Init.InitialOutput)
                                                                annotation (
      Placement(visible = true, transformation(origin = {20, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    SupportModels.ConnectorRelated.Conn conn1 annotation (
      Placement(visible = true, transformation(extent = {{-20, 60}, {20, 100}}, rotation = 0), iconTransformation(extent = {{-20, 78}, {20, 118}}, rotation = 0)));
    Modelica.Blocks.Math.Gain gain(k = genLoopGain) annotation (
      Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {84, -4})));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(visible = true, transformation(extent = {{36, -30}, {56, -50}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable1Ds toIceWref(fileName = "wToTau.txt", tableOnFile = false, table = [0, 0; 1884, 126; 9800, 126; 36600, 366; 52300, 523]) "optimal ice speed as a function of power" annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-16, -40})));
    Modelica.Blocks.Math.Gain toNm(k = maxTorqueReq) "converts p.u. torque request into Nm" annotation (
      Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-86, 30})));
    Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e6, uMin = 125) annotation (
      Placement(visible = true, transformation(origin = {14, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder genTauFilt(T = 1, initType=Modelica.Blocks.Types.Init.InitialOutput)
                                                            annotation (
      Placement(visible = true, transformation(origin = {84, 38}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Add add annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {18, 8})));
    Modelica.Blocks.Math.Feedback fbSOC annotation (
      Placement(transformation(extent = {{-50, 38}, {-30, 18}})));
    Modelica.Blocks.Math.Gain socErrToPow(k = socLoopGain) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-10, 28})));
    Modelica.Blocks.Sources.Constant socRef_(k = socRef) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-54, -2})));
  equation
    connect(powFilt.u, conn1.motPowDelB) annotation (
      Line(points={{20,58},{20,64},{-12,64},{-12,76},{0,76},{0,80}},            color = {0, 0, 127}));
    connect(gain.u, feedback.y) annotation (
      Line(points = {{84, -16}, {84, -16}, {84, -40}, {82, -40}, {56, -40}, {56, -40}, {55, -40}}, color = {0, 0, 127}));
    connect(feedback.u2, conn1.iceW) annotation (
      Line(points={{46,-32},{46,4},{40,4},{40,72},{0,72},{0,80}},              color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(toNm.u, tauReference) annotation (
      Line(points = {{-86, 18}, {-86, 0}, {-120, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toNm.y, conn1.motTauRef) annotation (
      Line(points = {{-86, 41}, {-86, 80}, {0, 80}}, color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(feedback.u1, limiter1.y) annotation (
      Line(points = {{38, -40}, {25, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(limiter1.u, toIceWref.y[1]) annotation (
      Line(points = {{2, -40}, {-5, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(genTauFilt.u, gain.y) annotation (
      Line(points = {{84, 26}, {84, 7}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(powFilt.y, add.u1) annotation (
      Line(points = {{20, 35}, {20, 26}, {24, 26}, {24, 20}}, color = {0, 0, 127}));
    connect(socErrToPow.y, add.u2) annotation (
      Line(points = {{1, 28}, {12, 28}, {12, 20}}, color = {0, 0, 127}));
    connect(fbSOC.y, socErrToPow.u) annotation (
      Line(points = {{-31, 28}, {-22, 28}}, color = {0, 0, 127}));
    connect(add.y, toIceWref.u) annotation (
      Line(points = {{18, -3}, {18, -3}, {18, -10}, {18, -12}, {18, -18}, {-40, -18}, {-40, -40}, {-28, -40}}, color = {0, 0, 127}));
    connect(fbSOC.u2, conn1.batSOC) annotation (
      Line(points = {{-40, 36}, {-40, 36}, {-40, 80}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(socRef_.y, fbSOC.u1) annotation (
      Line(points = {{-54, 9}, {-54, 28}, {-48, 28}}, color = {0, 0, 127}));
    connect(add.y, conn1.icePowRef) annotation (
      Line(points={{18,-3},{18,-12},{58,-12},{58,76},{0,76},{0,80}},                                   color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(genTauFilt.y, conn1.genTauRef) annotation (
      Line(points = {{84, 49}, {84, 49}, {84, 80}, {0, 80}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    annotation (
      Diagram(coordinateSystem(extent = {{-100, -60}, {100, 80}}, preserveAspectRatio = false, initialScale = 0.1), graphics={  Text(extent = {{-84, 68}, {-70, 56}}, textString = "Send 
requested
torque 
to mot",
     horizontalAlignment = TextAlignment.Left), Text(extent = {{54, 68}, {82, 58}}, textString = "send 
reference tau\nto gen",
     horizontalAlignment = TextAlignment.Right), Text(extent={{30,66},{56,
                54}}, textString = "send\nref pow\nto ice",
     horizontalAlignment = TextAlignment.Right),
     Line(origin={42,44}, points={{0,-6},{0,6},{0,6}},
     arrow = {Arrow.Filled, Arrow.None}),
     Line(origin={56,42}, points={{0,6},{0,-6},{0,-6}},
     arrow = {Arrow.Filled, Arrow.None}),
     Line(origin={88,68},   points={{0,6},{0,-6},{0,-6}},
     arrow = {Arrow.Filled, Arrow.None})}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(lineColor = {0, 0, 255}, extent = {{-100, -102}, {100, -140}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-4, -40}, {74, 16}, {74, -6}, {-4, -62}, {-4, -40}}, lineColor = {95, 95, 95}, fillColor = {175, 175, 175},
        fillPattern =  FillPattern.Solid), Polygon(points = {{8, -38}, {28, -48}, {20, -54}, {0, -44}, {8, -38}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{20, -54}, {28, -48}, {32, -56}, {24, -62}, {20, -54}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{24, -62}, {32, -56}, {32, -78}, {24, -84}, {24, -62}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{0, -44}, {20, -54}, {24, -62}, {24, -84}, {22, -84}, {22, -62}, {20, -58}, {0, -48}, {0, -44}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-14, 40}, {-18, 32}, {-10, 38}, {-8, 44}, {-14, 40}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-18, 32}, {-10, 38}, {-10, 14}, {-18, 8}, {-18, 32}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-20, 10}, {-20, 32}, {-16, 40}, {4, 30}, {4, 26}, {-16, 36}, {-18, 32}, {-18, 8}, {-20, 10}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-8, 46}, {12, 36}, {4, 30}, {-16, 40}, {-8, 46}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{28, -22}, {48, -32}, {40, -38}, {20, -28}, {28, -22}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{40, -38}, {48, -32}, {52, -40}, {44, -46}, {40, -38}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{44, -46}, {52, -40}, {52, -62}, {44, -68}, {44, -46}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{20, -28}, {40, -38}, {44, -46}, {44, -68}, {42, -68}, {42, -46}, {40, -42}, {20, -32}, {20, -28}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{48, -8}, {68, -18}, {60, -24}, {40, -14}, {48, -8}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{60, -24}, {68, -18}, {72, -26}, {64, -32}, {60, -24}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{64, -32}, {72, -26}, {72, -48}, {64, -54}, {64, -32}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{40, -14}, {60, -24}, {64, -32}, {64, -54}, {62, -54}, {62, -32}, {60, -28}, {40, -18}, {40, -14}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{68, 6}, {88, -4}, {80, -10}, {60, 0}, {68, 6}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{80, -10}, {88, -4}, {92, -12}, {84, -18}, {80, -10}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{84, -18}, {92, -12}, {92, -34}, {84, -40}, {84, -18}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{60, 0}, {80, -10}, {84, -18}, {84, -40}, {82, -40}, {82, -18}, {80, -14}, {60, -4}, {60, 0}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-34, 26}, {-38, 18}, {-30, 24}, {-28, 30}, {-34, 26}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-38, 18}, {-30, 24}, {-30, 0}, {-38, -6}, {-38, 18}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-40, -4}, {-40, 18}, {-36, 26}, {-16, 16}, {-16, 12}, {-36, 22}, {-38, 18}, {-38, -6}, {-40, -4}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-28, 32}, {-8, 22}, {-16, 16}, {-36, 26}, {-28, 32}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-54, 12}, {-58, 4}, {-50, 10}, {-48, 16}, {-54, 12}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-58, 4}, {-50, 10}, {-50, -14}, {-58, -20}, {-58, 4}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-60, -18}, {-60, 4}, {-56, 12}, {-36, 2}, {-36, -2}, {-56, 8}, {-58, 4}, {-58, -20}, {-60, -18}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-48, 18}, {-28, 8}, {-36, 2}, {-56, 12}, {-48, 18}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-74, -4}, {-78, -12}, {-70, -6}, {-68, 0}, {-74, -4}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-78, -12}, {-70, -6}, {-70, -30}, {-78, -36}, {-78, -12}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-80, -34}, {-80, -12}, {-76, -4}, {-56, -14}, {-56, -18}, {-76, -8}, {-78, -12}, {-78, -36}, {-80, -34}}, lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-68, 2}, {-48, -8}, {-56, -14}, {-76, -4}, {-68, 2}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-64, -8}, {-4, -40}, {-4, -62}, {-64, -30}, {-64, -8}}, lineColor = {95, 95, 95}, fillColor = {75, 75, 75},
        fillPattern =  FillPattern.Solid), Polygon(points = {{-64, -8}, {-4, -40}, {74, 16}, {14, 48}, {-64, -8}}, lineColor = {95, 95, 95}, fillColor = {160, 160, 164},
        fillPattern =  FillPattern.Solid), Rectangle(extent = {{-98, 92}, {98, 62}}, fillColor = {255, 255, 255},
        fillPattern =  FillPattern.Solid, pattern = LinePattern.None), Text(extent = {{-100, 82}, {100, 54}}, lineColor = {0, 0, 0}, textString = "PSD-ecu2")}),
      Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Power Split Power Train Controller without ON/OFF</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This controller is derived from MBecu1, in which the basic description can be found.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">It adds a soc control loop to avoid soc Drifts.</span></p>
</html>"));
  end Ecu2;

  model Ecu3 "Power Split hybrid power train controller, using ON/OFF strategy"
    parameter Real socRef = 0.6 "Reference soc";
    parameter Real maxTorqueReq = 80 "Maximum torque that can be requested from mot";
    parameter Real powFiltT = 60 "Power filter time constant (s)";
    parameter Real socLoopGain = 50e3 "gain of the soc loop (w/pu)";
    parameter Real genLoopGain = 0.02 "gain of the soc loop (Nm/(rad/s))";
    parameter Real onThreshold = 7000 "average power over which engine is switched on (W)";
    parameter Real offThreshold = 5000 "average power below which engine is switched off (W)";
    Modelica.Blocks.Interfaces.RealInput tauReference annotation (
      Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder powFilt(T = powFiltT, initType=Modelica.Blocks.Types.Init.InitialOutput)
                                                                annotation (
      Placement(visible = true, transformation(origin = {-50, 58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    SupportModels.ConnectorRelated.Conn conn annotation (
      Placement(visible = true, transformation(extent = {{-20, 78}, {20, 118}}, rotation = 0), iconTransformation(extent = {{-20, 78}, {20, 118}}, rotation = 0)));
    Modelica.Blocks.Math.Gain gain(k = genLoopGain) annotation (
      Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {104, 30})));
    Modelica.Blocks.Math.Gain toNm(k = maxTorqueReq) "converts p.u. torque request into Nm" annotation (
      Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-88, 50})));
    Modelica.Blocks.Continuous.FirstOrder genTauFilt(T = 1, initType=Modelica.Blocks.Types.Init.InitialOutput)
                                                            annotation (
      Placement(visible = true, transformation(origin = {104, 76}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Add add annotation (
      Placement(visible = true, transformation(origin = {-36, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable1Ds powToW(fileName = "wToTau.txt", tableOnFile = false, table = [0, 0; 1884, 126; 9800, 126; 36600, 366; 52300, 523]) "optimal ice speed as a function of power" annotation (
      Placement(visible = true, transformation(origin = {64, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Nonlinear.Limiter iceSpeedLimiter(uMax = 1e6, uMin = 125) annotation (
      Placement(visible = true, transformation(origin = {64, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(visible = true, transformation(extent = {{-10, 10}, {10, -10}}, rotation = 90, origin = {64, 46})));
    Modelica.Blocks.Sources.Constant socRef_(k = socRef) annotation (
      Placement(visible = true, transformation(extent = {{-98, -34}, {-78, -14}}, rotation = 0)));
    Modelica.Blocks.Math.Feedback fbSOC annotation (
      Placement(visible = true, transformation(extent = {{-74, -14}, {-54, -34}}, rotation = 0)));
    Modelica.Blocks.Math.Gain socErrrToPow(k = socLoopGain) annotation (
      Placement(visible = true, transformation(origin = {-38, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = offThreshold, uHigh = onThreshold) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-18, 42})));
    Modelica.Blocks.Logical.Switch switch1 annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {12, 12})));
    Modelica.Blocks.Sources.Constant constZero(k = 0) annotation (
      Placement(transformation(extent = {{20, -30}, {0, -10}})));
  equation
    connect(socErrrToPow.y, add.u2) annotation (
      Line(points = {{-27, -24}, {-22, -24}, {-22, -4}, {-58, -4}, {-58, 6}, {-48, 6}}, color = {0, 0, 127}));
    connect(socErrrToPow.u, fbSOC.y) annotation (
      Line(points = {{-50, -24}, {-55, -24}}, color = {0, 0, 127}));
    connect(fbSOC.u2, conn.batSOC) annotation (
      Line(points = {{-64, -16}, {-64, -12}, {-68, -12}, {-68, 98}, {0, 98}}, color = {0, 0, 127}));
    connect(fbSOC.u1, socRef_.y) annotation (
      Line(points = {{-72, -24}, {-77, -24}}, color = {0, 0, 127}));
    connect(feedback.u1, iceSpeedLimiter.y) annotation (
      Line(points = {{64, 38}, {64, 38}, {64, 28}, {64, 27}}, color = {0, 0, 127}));
    connect(feedback.u2, conn.iceW) annotation (
      Line(points={{56,46},{56,84},{6,84},{6,98},{0,98}},    color = {0, 0, 127}));
    connect(gain.u, feedback.y) annotation (
      Line(points = {{104, 18}, {104, 18}, {104, 0}, {88, 0}, {88, 55}, {64, 55}}, color = {0, 0, 127}));
    connect(iceSpeedLimiter.u, powToW.y[1]) annotation (
      Line(points = {{64, 4}, {64, -5}}, color = {0, 0, 127}));
    connect(add.u1, powFilt.y) annotation (
      Line(points = {{-48, 18}, {-54, 18}, {-58, 18}, {-58, 42}, {-50, 42}, {-50, 47}}, color = {0, 0, 127}));
    connect(powFilt.u, conn.motPowDelB) annotation (
      Line(points={{-50,70},{-50,80},{-22,80},{-22,96},{0,96},{0,98}},
                                                              color = {0, 0, 127}));
    connect(toNm.u, tauReference) annotation (
      Line(points = {{-88, 38}, {-88, 0}, {-120, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toNm.y, conn.motTauRef) annotation (
      Line(points = {{-88, 61}, {-88, 98}, {0, 98}}, color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(gain.y, genTauFilt.u) annotation (
      Line(points = {{104, 41}, {104, 64}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(genTauFilt.y, conn.genTauRef) annotation (
      Line(points = {{104, 87}, {104, 98}, {0, 98}}, color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(hysteresis.u, add.y) annotation (
      Line(points = {{-18, 30}, {-18, 12}, {-25, 12}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(hysteresis.y, conn.iceON) annotation (
      Line(points = {{-18, 53}, {-18, 92}, {0, 92}, {0, 98}}, color = {255, 0, 255}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    connect(powToW.u, switch1.y) annotation (
      Line(points = {{64, -28}, {30, -28}, {30, 12}, {23, 12}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(switch1.u1, add.y) annotation (
      Line(points = {{0, 20}, {-18, 20}, {-18, 12}, {-25, 12}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(switch1.u3, constZero.y) annotation (
      Line(points = {{0, 4}, {-8, 4}, {-8, -20}, {-1, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(switch1.u2, hysteresis.y) annotation (
      Line(points = {{0, 12}, {-8, 12}, {-8, 30}, {0, 30}, {0, 62}, {-18, 62}, {-18, 53}}, color = {255, 0, 255}, smooth = Smooth.None));
    connect(powToW.u, conn.icePowRef) annotation (
      Line(points={{64,-28},{30,-28},{30,70},{4,70},{4,96},{0,96},{0,98}},
                                                                        color = {0, 0, 127}, smooth = Smooth.None),
      Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
    annotation (
      Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Power Split Power Train Controller with ON/OFF</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This controller operates as follows:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">it makes the ice deliver the average power needed by the power train</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">it determines the optimal ice speed at which the requested power is delivered with minimum fuel consumption and asks the &quot;gen&quot; to control so that the ice operates at that speed</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">the vehicle motion is controlled acting on the &quot;mot&quot;.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">a closed-loop SOC control avoids the battery do become too charged or discharged</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">an ON/OFF control determines ICE switching OFF when the looad is to loow and switching it ON again when the requested power is significantly high. This normally reduces fuel consumpton.</span></li>
</ul>
<p><span style=\"font-family: MS Shell Dlg 2;\">So:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">powFilt Block filters the delivered power to obtained the power to ask the ICE to deliver</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">toIceWref converts the power to be requested from the ICE by its maximum torque at the actual speed</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">after a limiting block, this torque is the reference signal of a feedback; the corresponding error controls the Gen torque.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">fbSOC sis the feedback for SOC control and socLoopGain is its gain</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">hysteresis manages switching ON/OFF the ice. </span></li>
</ul>
<p>Details of ice going to off (e.g. bringing its speed to zero) and to on (i.e. first making ice speed to rise, then start sending fuel) are not implemented.</p>
</html>"),
      Diagram(coordinateSystem(extent = {{-100, -40}, {120, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(extent = {{-86, 92}, {-28, 88}}, textString = "Send requested torque to mot"), Text(extent={{
                14,50},{42,46}},
            lineColor={0,0,0},
            horizontalAlignment=TextAlignment.Left,
            textString="send\nreference\npow\nto ice"),
       Ellipse(extent={{-42,98},{50,-44}}, lineColor = {255, 0, 0},  lineThickness = 0.5),
       Line(origin={60,76},  points={{0, -6},{0,6},{0,6}}, arrow = {Arrow.Filled, Arrow.None}),
         Line(origin={0,78},   points={{0, 6},{0,-6},{0,-6}}, arrow = {Arrow.Filled, Arrow.None}),
         Line(origin={34,96},    points={{0, 6},{0,-6},{0,-6}},  arrow = {Arrow.Filled, Arrow.None},
            rotation=90)}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(lineColor = {0, 0, 255}, extent = {{-102, -102}, {98, -140}}, textString = "%name"), Rectangle(fillColor = {255, 255, 255},
        fillPattern =  FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(lineColor = {95, 95, 95}, fillColor = {175, 175, 175},
        fillPattern =  FillPattern.Solid, points = {{-4, -40}, {74, 16}, {74, -6}, {-4, -62}, {-4, -40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{8, -38}, {28, -48}, {20, -54}, {0, -44}, {8, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{20, -54}, {28, -48}, {32, -56}, {24, -62}, {20, -54}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{24, -62}, {32, -56}, {32, -78}, {24, -84}, {24, -62}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{0, -44}, {20, -54}, {24, -62}, {24, -84}, {22, -84}, {22, -62}, {20, -58}, {0, -48}, {0, -44}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-14, 40}, {-18, 32}, {-10, 38}, {-8, 44}, {-14, 40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-18, 32}, {-10, 38}, {-10, 14}, {-18, 8}, {-18, 32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-20, 10}, {-20, 32}, {-16, 40}, {4, 30}, {4, 26}, {-16, 36}, {-18, 32}, {-18, 8}, {-20, 10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-8, 46}, {12, 36}, {4, 30}, {-16, 40}, {-8, 46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{28, -22}, {48, -32}, {40, -38}, {20, -28}, {28, -22}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{40, -38}, {48, -32}, {52, -40}, {44, -46}, {40, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{44, -46}, {52, -40}, {52, -62}, {44, -68}, {44, -46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{20, -28}, {40, -38}, {44, -46}, {44, -68}, {42, -68}, {42, -46}, {40, -42}, {20, -32}, {20, -28}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{48, -8}, {68, -18}, {60, -24}, {40, -14}, {48, -8}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{60, -24}, {68, -18}, {72, -26}, {64, -32}, {60, -24}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{64, -32}, {72, -26}, {72, -48}, {64, -54}, {64, -32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{40, -14}, {60, -24}, {64, -32}, {64, -54}, {62, -54}, {62, -32}, {60, -28}, {40, -18}, {40, -14}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{68, 6}, {88, -4}, {80, -10}, {60, 0}, {68, 6}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{80, -10}, {88, -4}, {92, -12}, {84, -18}, {80, -10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{84, -18}, {92, -12}, {92, -34}, {84, -40}, {84, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{60, 0}, {80, -10}, {84, -18}, {84, -40}, {82, -40}, {82, -18}, {80, -14}, {60, -4}, {60, 0}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-34, 26}, {-38, 18}, {-30, 24}, {-28, 30}, {-34, 26}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-38, 18}, {-30, 24}, {-30, 0}, {-38, -6}, {-38, 18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-40, -4}, {-40, 18}, {-36, 26}, {-16, 16}, {-16, 12}, {-36, 22}, {-38, 18}, {-38, -6}, {-40, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-28, 32}, {-8, 22}, {-16, 16}, {-36, 26}, {-28, 32}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-54, 12}, {-58, 4}, {-50, 10}, {-48, 16}, {-54, 12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-58, 4}, {-50, 10}, {-50, -14}, {-58, -20}, {-58, 4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-60, -18}, {-60, 4}, {-56, 12}, {-36, 2}, {-36, -2}, {-56, 8}, {-58, 4}, {-58, -20}, {-60, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-48, 18}, {-28, 8}, {-36, 2}, {-56, 12}, {-48, 18}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-74, -4}, {-78, -12}, {-70, -6}, {-68, 0}, {-74, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-78, -12}, {-70, -6}, {-70, -30}, {-78, -36}, {-78, -12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-80, -34}, {-80, -12}, {-76, -4}, {-56, -14}, {-56, -18}, {-76, -8}, {-78, -12}, {-78, -36}, {-80, -34}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-68, 2}, {-48, -8}, {-56, -14}, {-76, -4}, {-68, 2}}), Polygon(lineColor = {95, 95, 95}, fillColor = {75, 75, 75},
        fillPattern =  FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {-4, -62}, {-64, -30}, {-64, -8}}), Polygon(lineColor = {95, 95, 95}, fillColor = {160, 160, 164},
        fillPattern =  FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {74, 16}, {14, 48}, {-64, -8}}), Rectangle(fillColor = {255, 255, 255}, pattern = LinePattern.None,
        fillPattern =  FillPattern.Solid, extent = {{-98, 92}, {98, 62}}), Text(extent = {{-100, 84}, {100, 58}}, lineColor = {0, 0, 0}, textString = "PSD-ecu3")}));
  end Ecu3;

  model GMS "Genset Management System (simplified)"
    parameter Real contrGain = 0.01 "speed controller gain (throttle per rad/s)";
    parameter String mapsFileName = "maps.txt" "File name where optimal speed is stored";
    import Modelica.Constants.pi;
    Modelica.Blocks.Tables.CombiTable1Dv optiSpeed(
      tableOnFile=true,
      columns={2},
      tableName="optiSpeed",
      fileName=mapsFileName)
      "gives the optimal speed as a function of requested power"
      annotation (Placement(transformation(extent={{-42,-50},{-22,-30}})));
    Modelica.Blocks.Math.Division division annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-30, 48})));
    Modelica.Blocks.Interfaces.RealInput Wmecc annotation (
      Placement(transformation(extent = {{-15, -15}, {15, 15}}, rotation = 90, origin = {1, -115}), iconTransformation(extent = {{-15, -15}, {15, 15}}, rotation = 90, origin = {1, -115})));
    Modelica.Blocks.Interfaces.RealInput pRef annotation (
      Placement(transformation(extent = {{-134, -20}, {-94, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
    Modelica.Blocks.Interfaces.RealOutput tRef "Torque request (positive when ICE delivers power)" annotation (
      Placement(transformation(extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
    Modelica.Blocks.Interfaces.RealOutput throttle annotation (
      Placement(transformation(extent = {{100, -70}, {120, -50}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(transformation(extent = {{24, -50}, {44, -30}})));
    Modelica.Blocks.Math.Gain gain(k = 0.01) annotation (
      Placement(transformation(extent = {{66, -50}, {86, -30}})));
    Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {34, -70})));
    Modelica.Blocks.Tables.CombiTable1Dv maxTau(
      columns={2},
      extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
      fileName=mapsFileName,
      tableName="maxIceTau",
      tableOnFile=true)
      "gives the optimal spees ad a function of requested power"
      annotation (Placement(transformation(extent={{6,68},{26,88}})));
    Modelica.Blocks.Nonlinear.VariableLimiter tauLimiter annotation (
      Placement(transformation(extent = {{48, 50}, {68, 70}})));
    Modelica.Blocks.Math.Gain gain1(k = -1) annotation (
      Placement(transformation(extent = {{20, 28}, {36, 44}})));
  equation
    connect(division.u1, optiSpeed.u[1]) annotation (
      Line(points = {{-36, 36}, {-36, 0}, {-60, 0}, {-60, -40}, {-44, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(optiSpeed.u[1], pRef) annotation (
      Line(points = {{-44, -40}, {-60, -40}, {-60, 0}, {-114, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(throttle, gain.y) annotation (
      Line(points = {{110, -60}, {98, -60}, {98, -40}, {87, -40}}, color = {0, 0, 127}));
    connect(feedback.y, gain.u) annotation (
      Line(points = {{43, -40}, {64, -40}}, color = {0, 0, 127}));
    connect(feedback.u1, optiSpeed.y[1]) annotation (
      Line(points = {{26, -40}, {4, -40}, {-21, -40}}, color = {0, 0, 127}));
    connect(to_rpm.y, feedback.u2) annotation (
      Line(points = {{34, -59}, {34, -59}, {34, -48}}, color = {0, 0, 127}));
    connect(to_rpm.u, Wmecc) annotation (
      Line(points = {{34, -82}, {34, -94}, {1, -94}, {1, -115}}, color = {0, 0, 127}));
    connect(division.u2, Wmecc) annotation (
      Line(points = {{-24, 36}, {-24, 0}, {-6, 0}, {-6, -96}, {1, -96}, {1, -115}}, color = {0, 0, 127}));
    connect(tauLimiter.y, tRef) annotation (
      Line(points = {{69, 60}, {84, 60}, {110, 60}}, color = {0, 0, 127}));
    connect(tauLimiter.limit1, maxTau.y[1]) annotation (
      Line(points = {{46, 68}, {36, 68}, {36, 78}, {27, 78}}, color = {0, 0, 127}));
    connect(maxTau.u[1], Wmecc) annotation (
      Line(points = {{4, 78}, {0, 78}, {0, -115}, {1, -115}}, color = {0, 0, 127}));
    connect(division.y, tauLimiter.u) annotation (
      Line(points = {{-30, 59}, {-32, 59}, {-32, 60}, {46, 60}}, color = {0, 0, 127}));
    connect(gain1.y, tauLimiter.limit2) annotation (
      Line(points = {{36.8, 36}, {40, 36}, {40, 34}, {40, 52}, {46, 52}}, color = {0, 0, 127}));
    connect(gain1.u, maxTau.y[1]) annotation (
      Line(points = {{18.4, 36}, {12, 36}, {12, 54}, {36, 54}, {36, 78}, {27, 78}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
      experimentSetupOutput,
      Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255},
        fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}),
          Text(origin = {-2, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255},
        fillPattern = FillPattern.Solid, extent = {{-98, 22}, {98, -16}}, textString = "%name")}),
      Documentation(info = "<html>
<p>Genset Management System.</p>
<p>The control logic commands the genset to deliver at the DC port the input power, using the optimal generator speed.</p>
</html>"));
  end GMS;

  model GMSoo "Genset Management System (simplified)"
    parameter Real tauMax = 100 "maximum torque internally exchanged by the two machines";
    parameter Real throttlePerWerr = 0.01 "speed controller gain (throttle per rad/s)";
    parameter Boolean tablesOnFile = false;
    parameter String mapsFileName = "maps.txt" "Name of the file containing data maps (names: maxIceTau, specificCons, optiSpeed)" annotation (
      Dialog(enable = tablesOnFile));
    parameter Real optiTable[:, :] = [0, 800; 20000, 850; 40000, 1100; 60000, 1250; 80000, 1280; 100000, 1340; 120000, 1400; 140000, 1650; 160000, 2130] "first row: speed, 1st column: torque, body: sp. consumption" annotation (
      Dialog(enable = not tablesOnFile));
    import Modelica.Constants.pi;
    Modelica.Blocks.Tables.CombiTable1Dv optiSpeed(
      columns={2},
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
      table=optiTable,
      fileName=mapsFileName,
      tableOnFile=tablesOnFile,
      tableName="optiSpeed")
      "gives the optimal spees ad a function of requested power"
      annotation (Placement(visible=true, transformation(extent={{-66,-22},
              {-46,-2}}, rotation=0)));
    Modelica.Blocks.Math.Division division annotation (
      Placement(visible = true, transformation(origin = {4, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Interfaces.RealInput Wmecc annotation (
      Placement(visible = true, transformation(origin = {0, -96}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {1, -115}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
    Modelica.Blocks.Interfaces.RealInput pRef annotation (
      Placement(visible = true, transformation(extent = {{-140, -60}, {-100, -20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput tRef "Torque request (positive when ICE delivers power)" annotation (
      Placement(visible = true, transformation(extent = {{100, 30}, {120, 50}}, rotation = 0), iconTransformation(extent = {{100, 50}, {120, 70}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput throttle annotation (
      Placement(visible = true, transformation(extent = {{100, -50}, {120, -30}}, rotation = 0), iconTransformation(extent = {{100, -70}, {120, -50}}, rotation = 0)));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(visible = true, transformation(extent = {{24, -30}, {44, -10}}, rotation = 0)));
    Modelica.Blocks.Math.Gain gain(k = throttlePerWerr) annotation (
      Placement(visible = true, transformation(extent = {{66, -30}, {86, -10}}, rotation = 0)));
    Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm annotation (
      Placement(visible = true, transformation(origin = {34, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Interfaces.BooleanInput on annotation (
      Placement(visible = true, transformation(extent = {{-138, 28}, {-98, 68}}, rotation = 0), iconTransformation(extent = {{-138, 40}, {-98, 80}}, rotation = 0)));
    Modelica.Blocks.Logical.Switch switch1 annotation (
      Placement(visible = true, transformation(extent = {{-18, -30}, {2, -10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant zero(k = 0) annotation (
      Placement(visible = true, transformation(extent = {{-60, -60}, {-40, -40}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.Limiter limMinW(uMax = 1e9, uMin = 10) annotation (
      Placement(visible = true, transformation(origin = {4, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Tables.CombiTable1Dv maxTau(
      tableOnFile=true,
      columns={2},
      fileName=mapsFileName,
      tableName="maxIceTau")
      "gives the optimal spees ad a function of requested power"
      annotation (Placement(transformation(extent={{14,38},{34,58}})));
    Modelica.Blocks.Math.Gain gain1(k = -1) annotation (
      Placement(transformation(extent = {{34, 4}, {50, 20}})));
    Modelica.Blocks.Nonlinear.VariableLimiter tauLimiter annotation (
      Placement(transformation(extent = {{62, 26}, {82, 46}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y = Wmecc) annotation (
      Placement(transformation(extent = {{-24, 36}, {-4, 56}})));
  equation
    connect(to_rpm.u, Wmecc) annotation (
      Line(points = {{34, -62}, {34, -70}, {0, -70}, {0, -96}}, color = {0, 0, 127}));
    connect(zero.y, switch1.u3) annotation (
      Line(points = {{-39, -50}, {-30, -50}, {-30, -28}, {-20, -28}}, color = {0, 0, 127}));
    connect(on, switch1.u2) annotation (
      Line(points = {{-118, 48}, {-34, 48}, {-34, -20}, {-20, -20}}, color = {255, 0, 255}));
    connect(optiSpeed.y[1], switch1.u1) annotation (
      Line(points = {{-45, -12}, {-45, -12}, {-20, -12}}, color = {0, 0, 127}));
    connect(switch1.y, feedback.u1) annotation (
      Line(points = {{3, -20}, {26, -20}}, color = {0, 0, 127}));
    connect(to_rpm.y, feedback.u2) annotation (
      Line(points = {{34, -39}, {34, -39}, {34, -28}}, color = {0, 0, 127}));
    connect(feedback.y, gain.u) annotation (
      Line(points = {{43, -20}, {64, -20}}, color = {0, 0, 127}));
    connect(throttle, gain.y) annotation (
      Line(points = {{110, -40}, {98, -40}, {98, -20}, {87, -20}}, color = {0, 0, 127}));
    connect(division.u1, optiSpeed.u[1]) annotation (
      Line(points = {{-2, 4}, {-80, 4}, {-80, -12}, {-68, -12}}, color = {0, 0, 127}));
    connect(optiSpeed.u[1], pRef) annotation (
      Line(points = {{-68, -12}, {-80, -12}, {-80, -40}, {-120, -40}}, color = {0, 0, 127}));
    connect(limMinW.u, Wmecc) annotation (
      Line(points = {{4, -60}, {4, -70}, {0, -70}, {0, -96}}, color = {0, 0, 127}));
    connect(limMinW.y, division.u2) annotation (
      Line(points = {{4, -37}, {6, -37}, {6, 4}, {10, 4}}, color = {0, 0, 127}));
    connect(tauLimiter.y, tRef) annotation (
      Line(points = {{83, 36}, {96, 36}, {96, 40}, {110, 40}}, color = {0, 0, 127}));
    connect(maxTau.y[1], tauLimiter.limit1) annotation (
      Line(points = {{35, 48}, {60, 48}, {60, 44}}, color = {0, 0, 127}));
    connect(tauLimiter.limit2, gain1.y) annotation (
      Line(points = {{60, 28}, {58, 28}, {58, 26}, {50.8, 26}, {50.8, 12}}, color = {0, 0, 127}));
    connect(gain1.u, tauLimiter.limit1) annotation (
      Line(points = {{32.4, 12}, {26, 12}, {26, 30}, {44, 30}, {44, 48}, {60, 48}, {60, 44}}, color = {0, 0, 127}));
    connect(division.y, tauLimiter.u) annotation (
      Line(points = {{4, 27}, {4, 36}, {60, 36}}, color = {0, 0, 127}));
    connect(realExpression.y, maxTau.u[1]) annotation (
      Line(points = {{-3, 46}, {4, 46}, {4, 48}, {12, 48}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 60}})),
      Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255},
        fillPattern =  FillPattern.Solid, extent = {{-100, 100}, {100, -100}}),
          Text(origin = {-2, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255},
        fillPattern =  FillPattern.Solid, extent = {{-98, 22}, {98, -16}}, textString = "%name")}),
      Documentation(info = "<html>
<p>Genset Management System witn ON/OFF.</p>
<p>The control logic commands the genset to deliver at the DC port the input power, using the optimal generator speed.</p>
<p>In addition, it commands ON or OFF depending on the input boolean control signal.</p>
</html>"),
      __OpenModelica_commandLineOptions = "");
  end GMSoo;

  block EleBalanceTau
    parameter Real sigma;
    Modelica.Blocks.Interfaces.RealInput motW annotation (
      Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {-60, 116})));
    Modelica.Blocks.Interfaces.RealInput iceW annotation (
      Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {60, 114})));
    Modelica.Blocks.Interfaces.RealOutput tauMot annotation (
      Placement(transformation(extent = {{98, -10}, {118, 10}})));
    Modelica.Blocks.Interfaces.RealInput tauP annotation (
      Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {0, 116})));
  equation
    tauMot = tauP * ((1 + sigma) * iceW - motW) / ((1 + sigma) * iceW);
    annotation (
      Icon(coordinateSystem(preserveAspectRatio = false)),
      Diagram(coordinateSystem(preserveAspectRatio = false)));
  end EleBalanceTau;

  model EMS "Ice, Generator, DriveTrain, all map-based"
    //€
    parameter Real tauPowFilt = 300 "power filter time constant";
    parameter Real powLow = 3000 "hysteresis control lower limit";
    parameter Real powHigh = 5000 "hysteresis control higher limit";
    parameter Real powPerSoc = 100e3 "SOC loop gain";
    parameter Real powMax = 100e3 "Max power that can be requested as output";
    parameter Real socRef = 0.7;
    Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = powMax) annotation (
      Placement(visible = true, transformation(origin = {12, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.Feedback fbSOC annotation (
      Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant socRef_(k = socRef) annotation (
      Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
    Modelica.Blocks.Math.Gain socErrToPow(k = powPerSoc) annotation (
      Placement(visible = true, transformation(origin = {-40, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Math.Add add annotation (
      Placement(visible = true, transformation(origin = {-18, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput edPow annotation (
      Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput soc annotation (
      Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Logical.Switch powSwitch annotation (
      Placement(visible = true, transformation(origin = {64, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Logical.Hysteresis powHyst(uHigh = powHigh, uLow = powLow) annotation (
      Placement(visible = true, transformation(origin = {50, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant zero(k = 0.0) annotation (
      Placement(visible = true, transformation(origin = {26, -48}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
    Modelica.Blocks.Interfaces.BooleanOutput on annotation (
      Placement(visible = true, transformation(extent = {{100, 30}, {120, 50}}, rotation = 0), iconTransformation(extent = {{98, 50}, {118, 70}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput pcPowReq(displayUnit = "kW") annotation (
      Placement(visible = true, transformation(extent = {{100, -50}, {120, -30}}, rotation = 0), iconTransformation(extent = {{98, -70}, {118, -50}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder powFilt(y_start = 20e3, T = tauPowFilt) annotation (
      Placement(transformation(extent = {{-72, 44}, {-56, 60}})));
  equation
    connect(powSwitch.u1, limiter.y) annotation (
      Line(points = {{52, -12}, {30, -12}, {30, 46}, {23, 46}}, color = {0, 0, 127}));
    connect(powSwitch.u3, zero.y) annotation (
      Line(points = {{52, -28}, {44, -28}, {44, -48}, {37, -48}}, color = {0, 0, 127}));
    connect(powHyst.u, limiter.y) annotation (
      Line(points = {{38, 46}, {23, 46}}, color = {0, 0, 127}));
    connect(socErrToPow.y, add.u2) annotation (
      Line(points = {{-40, 33}, {-40, 40}, {-30, 40}}, color = {0, 0, 127}));
    connect(limiter.u, add.y) annotation (
      Line(points = {{0, 46}, {0, 46}, {-7, 46}}, color = {0, 0, 127}));
    connect(socErrToPow.u, fbSOC.y) annotation (
      Line(points = {{-40, 10}, {-40, 0}, {-51, 0}}, color = {0, 0, 127}));
    connect(fbSOC.u2, soc) annotation (
      Line(points = {{-60, -8}, {-60, -40}, {-120, -40}}, color = {0, 0, 127}));
    connect(socRef_.y, fbSOC.u1) annotation (
      Line(points = {{-79, -1.33227e-015}, {-76, -1.33227e-015}, {-76, 0}, {-74, 0}, {-68, 0}}, color = {0, 0, 127}));
    connect(powSwitch.u2, on) annotation (
      Line(points = {{52, -20}, {40, -20}, {26, -20}, {26, 22}, {88, 22}, {88, 40}, {110, 40}}, color = {255, 0, 255}));
    connect(powSwitch.y, pcPowReq) annotation (
      Line(points = {{75, -20}, {84, -20}, {84, -40}, {110, -40}}, color = {0, 0, 127}));
    connect(powFilt.y, add.u1) annotation (
      Line(points = {{-55.2, 52}, {-44, 52}, {-30, 52}}, color = {0, 0, 127}));
    connect(powFilt.u, edPow) annotation (
      Line(points = {{-73.6, 52}, {-78, 52}, {-78, 40}, {-120, 40}}, color = {0, 0, 127}));
    connect(powHyst.y, on) annotation (
      Line(points = {{61, 46}, {88, 46}, {88, 40}, {110, 40}}, color = {255, 0, 255}));
    annotation (
      Placement(visible = true, transformation(origin = {-58, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)),
      Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}})),
      Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(fillColor = {255, 255, 255},
        fillPattern =  FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(lineColor = {95, 95, 95}, fillColor = {175, 175, 175},
        fillPattern =  FillPattern.Solid, points = {{-4, -40}, {74, 16}, {74, -6}, {-4, -62}, {-4, -40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{8, -38}, {28, -48}, {20, -54}, {0, -44}, {8, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{20, -54}, {28, -48}, {32, -56}, {24, -62}, {20, -54}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{24, -62}, {32, -56}, {32, -78}, {24, -84}, {24, -62}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{0, -44}, {20, -54}, {24, -62}, {24, -84}, {22, -84}, {22, -62}, {20, -58}, {0, -48}, {0, -44}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-14, 40}, {-18, 32}, {-10, 38}, {-8, 44}, {-14, 40}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-18, 32}, {-10, 38}, {-10, 14}, {-18, 8}, {-18, 32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-20, 10}, {-20, 32}, {-16, 40}, {4, 30}, {4, 26}, {-16, 36}, {-18, 32}, {-18, 8}, {-20, 10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-8, 46}, {12, 36}, {4, 30}, {-16, 40}, {-8, 46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{28, -22}, {48, -32}, {40, -38}, {20, -28}, {28, -22}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{40, -38}, {48, -32}, {52, -40}, {44, -46}, {40, -38}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{44, -46}, {52, -40}, {52, -62}, {44, -68}, {44, -46}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{20, -28}, {40, -38}, {44, -46}, {44, -68}, {42, -68}, {42, -46}, {40, -42}, {20, -32}, {20, -28}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{48, -8}, {68, -18}, {60, -24}, {40, -14}, {48, -8}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{60, -24}, {68, -18}, {72, -26}, {64, -32}, {60, -24}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{64, -32}, {72, -26}, {72, -48}, {64, -54}, {64, -32}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{40, -14}, {60, -24}, {64, -32}, {64, -54}, {62, -54}, {62, -32}, {60, -28}, {40, -18}, {40, -14}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{68, 6}, {88, -4}, {80, -10}, {60, 0}, {68, 6}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{80, -10}, {88, -4}, {92, -12}, {84, -18}, {80, -10}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{84, -18}, {92, -12}, {92, -34}, {84, -40}, {84, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{60, 0}, {80, -10}, {84, -18}, {84, -40}, {82, -40}, {82, -18}, {80, -14}, {60, -4}, {60, 0}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-34, 26}, {-38, 18}, {-30, 24}, {-28, 30}, {-34, 26}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-38, 18}, {-30, 24}, {-30, 0}, {-38, -6}, {-38, 18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-40, -4}, {-40, 18}, {-36, 26}, {-16, 16}, {-16, 12}, {-36, 22}, {-38, 18}, {-38, -6}, {-40, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-28, 32}, {-8, 22}, {-16, 16}, {-36, 26}, {-28, 32}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-54, 12}, {-58, 4}, {-50, 10}, {-48, 16}, {-54, 12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-58, 4}, {-50, 10}, {-50, -14}, {-58, -20}, {-58, 4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-60, -18}, {-60, 4}, {-56, 12}, {-36, 2}, {-36, -2}, {-56, 8}, {-58, 4}, {-58, -20}, {-60, -18}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-48, 18}, {-28, 8}, {-36, 2}, {-56, 12}, {-48, 18}}), Polygon(lineColor = {128, 128, 128}, fillColor = {128, 128, 128},
        fillPattern =  FillPattern.Solid, points = {{-74, -4}, {-78, -12}, {-70, -6}, {-68, 0}, {-74, -4}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 127},
        fillPattern =  FillPattern.Solid, points = {{-78, -12}, {-70, -6}, {-70, -30}, {-78, -36}, {-78, -12}}), Polygon(lineColor = {0, 0, 255}, fillColor = {191, 191, 0},
        fillPattern =  FillPattern.Solid, points = {{-80, -34}, {-80, -12}, {-76, -4}, {-56, -14}, {-56, -18}, {-76, -8}, {-78, -12}, {-78, -36}, {-80, -34}}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 0},
        fillPattern =  FillPattern.Solid, points = {{-68, 2}, {-48, -8}, {-56, -14}, {-76, -4}, {-68, 2}}), Polygon(lineColor = {95, 95, 95}, fillColor = {75, 75, 75},
        fillPattern =  FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {-4, -62}, {-64, -30}, {-64, -8}}), Polygon(lineColor = {95, 95, 95}, fillColor = {160, 160, 164},
        fillPattern =  FillPattern.Solid, points = {{-64, -8}, {-4, -40}, {74, 16}, {14, 48}, {-64, -8}}), Rectangle(fillColor = {255, 255, 255}, pattern = LinePattern.None,
        fillPattern =  FillPattern.Solid, extent = {{-98, 92}, {98, 62}}), Text(origin = {-6.08518, -4.3529}, lineColor = {0, 0, 255}, extent = {{-91.9148, 98.3529}, {100.085, 60.353}}, textString = "%name", fontName = "Helvetica")}),
      experimentSetupOutput(derivatives = false),
      Documentation(info = "<html>
<p>SHEV logic. Contains:</p>
<p>- basic logic, which requests the average load power from the ICE</p>
<p>- additional SOC loop to avoid SOC drift</p>
<p>- further ON/OFF control to switch OFF the engine when the average power is too low to permit efficient operation</p>
</html>"),
      __OpenModelica_commandLineOptions = "");
  end EMS;
end ECUs;
