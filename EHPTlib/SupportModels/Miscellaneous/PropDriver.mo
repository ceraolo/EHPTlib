within EHPTlib.SupportModels.Miscellaneous;
block PropDriver "Simple Proportional controller driver"
  parameter String CycleFileName = "cycleName.txt" "Drive Cycle Name ex: \"sort1.txt\"";
  parameter Real k "Controller gain";
  parameter Real yMax = 1.e6 "Max output value (absolute)";
  parameter Modelica.Blocks.Types.Extrapolation extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints "Extrapolation of data outside the definition range";
protected
  parameter Boolean dummy(fixed = false);
  //Used only to render exrapolation a structural parameter.
  // This is important, otherwise the user could falsely believe that they can change it at run time,
  //which is not possible because it is passed to a CombiTable for which (at least in OpenModelica),
  //the extrapolation parameter is structural.
public
  Modelica.Blocks.Interfaces.RealInput V annotation (
    Placement(visible = true, transformation(origin = {0, -66}, extent = {{-14, -14}, {14, 14}}, rotation = 90), iconTransformation(origin = {0, -112}, extent = {{-12, -12}, {12, 12}}, rotation = 90)));
  Modelica.Blocks.Math.UnitConversions.From_kmh from_kmh annotation (
    Placement(visible = true, transformation(extent = {{-42, -10}, {-22, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable driveCyc(columns = {2}, extrapolation = extrapolation, fileName = CycleFileName, tableName = "Cycle", tableOnFile = true) annotation (
    Placement(visible = true, transformation(extent = {{-80, -10}, {-60, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation (
    Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SupportModels.Miscellaneous.Gain gain(k = k) annotation (
    Placement(visible = true, transformation(extent = {{14, -10}, {34, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limAcc(uMax = yMax, uMin = 0) annotation (
    Placement(visible = true, transformation(origin = {2, 40}, extent = {{52, -10}, {72, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limBrak(uMax = 0, uMin = -yMax) annotation (
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{52, -10}, {72, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput tauRef(unit = "N.m") annotation (
    Placement(visible = true, transformation(extent = {{100, -10}, {120, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput accelTau(unit = "N.m") annotation (
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent={{100,40},
            {120,60}},                                                                                                                                               rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput brakeTau(unit = "N.m") annotation (
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent={{100,-60},
            {120,-40}},                                                                                                                                                 rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=yMax) annotation (
      Placement(visible=true, transformation(
        origin={4,0},
        extent={{52,-10},{72,10}},
        rotation=0)));
initial equation
  //For the meaning of the following if see the definition of dummy
  if extrapolation == Modelica.Blocks.Types.Extrapolation.HoldLastPoint then
    dummy = true;
  else
    dummy = false;
  end if;
equation
  connect(V, feedback.u2) annotation (
    Line(points = {{0, -66}, {0, -66}, {0, -8}, {0, -8}}, color = {0, 0, 127}));
  connect(from_kmh.u, driveCyc.y[1]) annotation (
    Line(points = {{-44, 0}, {-59, 0}}, color = {0, 0, 127}));
  connect(from_kmh.y, feedback.u1) annotation (
    Line(points = {{-21, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation (
    Line(points = {{9, 0}, {12, 0}}, color = {0, 0, 127}));
  connect(limBrak.y, brakeTau) annotation (
    Line(points = {{73, -40}, {104, -40}, {104, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(limAcc.y, accelTau) annotation (
    Line(points = {{75, 40}, {102, 40}, {102, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(limBrak.u, gain.y) annotation (
    Line(points = {{50, -40}, {40, -40}, {40, 0}, {35, 0}, {35, 0}}, color = {0, 0, 127}));
  connect(limAcc.u, gain.y) annotation (
    Line(points = {{52, 40}, {40, 40}, {40, 0}, {35, 0}, {35, 0}}, color = {0, 0, 127}));
  connect(limiter1.u, gain.y) annotation (
    Line(points = {{54, 0}, {34, 0}, {34, 0}, {35, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, tauRef) annotation (
    Line(points = {{77, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation (
    Documentation(info = "<html><head></head><body><p>Simple driver model.</p><p>It reads a reference cycle from a file then controls speed with a simple proportional feedback law.</p>
            </body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1),
    graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid,
    extent = {{-100, 100}, {100, -100}}), Ellipse(fillColor = {255, 213, 170},
    fillPattern = FillPattern.Solid, extent = {{-23, 22}, {-12, -4}},
    endAngle = 360), Text(origin = {2, -0.1894}, lineColor = {0, 0, 255},
    extent = {{-104, 142.189}, {98, 104}}, textString = "%name"),
    Polygon(fillColor = {215, 215, 215}, pattern = LinePattern.None,
    fillPattern = FillPattern.Solid, points = {{-22, -60}, {-42, -88}, {-16, -88}, {16, -88}, {-22, -60}}),
    Polygon(fillColor = {135, 135, 135}, pattern = LinePattern.None, fillPattern = FillPattern.Solid,
    points = {{-32, 40}, {-62, -52}, {-30, -52}, {-30, -52}, {-32, 40}},
    smooth = Smooth.Bezier), Polygon(fillColor = {135, 135, 135},
    pattern = LinePattern.None, fillPattern = FillPattern.Solid,
    points = {{-68, -36}, {-14, -90}, {10, -50}, {0, -50}, {-68, -36}},
    smooth = Smooth.Bezier), Polygon(fillColor = {175, 175, 175},
    fillPattern = FillPattern.Solid, points = {{-22, 10}, {-30, 6}, {-40, -48}, {2, -46}, {2, -34}, {0, 2}, {-22, 10}},
    smooth = Smooth.Bezier), Ellipse(fillColor = {255, 213, 170},
    fillPattern = FillPattern.Solid, extent = {{-30, 44}, {-3, 10}},
    endAngle = 360), Polygon(pattern = LinePattern.None,
    fillPattern = FillPattern.Solid, points = {{-38, 34}, {-16, 50}, {-2, 36}, {4, 36}, {6, 36}, {-38, 34}},
    smooth = Smooth.Bezier), Polygon(fillColor = {95, 95, 95},
    fillPattern = FillPattern.Solid, points = {{30, -44}, {-32, -28}, {-36, -44}, {-24, -58}, {30, -44}}, smooth = Smooth.Bezier), Polygon(fillPattern = FillPattern.Solid, points = {{42, -70}, {36, -84}, {48, -78}, {52, -72}, {50, -68}, {42, -70}}, smooth = Smooth.Bezier), Line(points = {{48, -14}, {26, 0}, {26, 0}}, thickness = 0.5), Line(points = {{20, -10}, {34, 10}, {34, 10}}, thickness = 0.5), Polygon(fillColor = {255, 213, 170}, fillPattern = FillPattern.Solid, points = {{28, 4}, {32, 8}, {28, 2}, {34, 6}, {30, 2}, {34, 4}, {30, 0}, {26, 2}, {34, 0}, {26, 0}, {26, 2}, {28, 4}, {28, 4}, {26, 2}, {26, 2}, {26, 2}, {28, 8}, {28, 6}, {28, 4}}, smooth = Smooth.Bezier), Polygon(fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, points = {{-18, 0}, {28, 6}, {26, -2}, {-16, -16}, {-20, -16}, {-24, -6}, {-18, 0}}, smooth = Smooth.Bezier), Polygon(fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid, points = {{72, -6}, {48, -6}, {36, -26}, {58, -86}, {72, -86}, {72, -6}}), Polygon(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, points = {{49, -94}, {17, -40}, {7, -44}, {-1, -50}, {49, -94}}, smooth = Smooth.Bezier), Line(points = {{-7, 31}, {-3, 29}}), Line(points = {{-9, 18}, {-5, 18}}), Line(points = {{-7, 31}, {-3, 31}}), Text(lineColor = {238, 46, 47}, extent = {{-100, 90}, {100, 58}}, textString = "%CycleFileName")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}},
    preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})));
end PropDriver;
