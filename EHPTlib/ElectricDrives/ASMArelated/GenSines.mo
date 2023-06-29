within EHPTlib.ElectricDrives.ASMArelated;
block GenSines "Generates three-phase sine waves"
  import Modelica.Constants.pi;
  Modelica.Blocks.Interfaces.RealInput Westar annotation (
    Placement(transformation(extent = {{-140, 28}, {-100, 68}}), iconTransformation(extent = {{-13, -13}, {13, 13}}, rotation = 0, origin = {-113, 59})));
  Modelica.Blocks.Interfaces.RealOutput U[3] annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}}), iconTransformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Blocks.Interfaces.RealInput Ustar "RMS phase" annotation (
    Placement(transformation(extent = {{-140, -60}, {-100, -20}}), iconTransformation(extent = {{-13, -13}, {13, 13}}, rotation = 0, origin = {-113, -59})));
  Modelica.Blocks.Math.Add add1[3] annotation (
    Placement(transformation(extent = {{0, 38}, {20, 58}})));
  Modelica.Blocks.Math.Sin sin[3] annotation (
    Placement(transformation(extent = {{34, 38}, {54, 58}})));
  Modelica.Blocks.Continuous.Integrator integrator annotation (
    Placement(transformation(extent = {{-72, 38}, {-52, 58}})));
  Modelica.Blocks.Routing.Replicator replicator(nout = 3) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {60, 8})));
  Modelica.Blocks.Math.Product product[3] annotation (
    Placement(transformation(extent = {{72, 28}, {92, 48}})));
  Modelica.Blocks.Math.Gain ToPeak(k = sqrt(2)) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {60, -22})));
  Modelica.Blocks.Sources.Constant phase[3](k = 2 * pi / 3 * {0, -1, 1}) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-10, 8})));
  Modelica.Blocks.Routing.Replicator replicator1(nout = 3) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-30, 48})));
equation
  connect(sin.u, add1.y) annotation (
    Line(points = {{32, 48}, {21, 48}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(product.y, U) annotation (
    Line(points = {{93, 38}, {102, 38}, {102, 0}, {110, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(product.u2, replicator.y) annotation (
    Line(points = {{70, 32}, {60, 32}, {60, 19}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(ToPeak.y, replicator.u) annotation (
    Line(points = {{60, -11}, {60, -4}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(sin.y, product.u1) annotation (
    Line(points = {{55, 48}, {62, 48}, {62, 44}, {70, 44}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(add1.u1, replicator1.y) annotation (
    Line(points = {{-2, 54}, {-10, 54}, {-10, 48}, {-19, 48}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(add1.u2, phase.y) annotation (
    Line(points = {{-2, 42}, {-10, 42}, {-10, 19}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(replicator1.u, integrator.y) annotation (
    Line(points = {{-42, 48}, {-51, 48}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(integrator.u, Westar) annotation (
    Line(points = {{-74, 48}, {-82, 48}, {-88, 48}, {-120, 48}}, color = {0, 0, 127}));
  connect(ToPeak.u, Ustar) annotation (
    Line(points = {{60, -34}, {60, -34}, {60, -40}, {-120, -40}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 144}, {98, 106}}, textString = "%name"), Line(points = {{-4, 28}, {8, 48}, {28, 48}, {48, 8}, {70, 8}, {82, 28}}), Line(points = {{-6, 4}, {6, 24}, {26, 24}, {46, -16}, {68, -16}, {80, 4}}), Line(points = {{-8, -16}, {4, 4}, {24, 4}, {44, -36}, {66, -36}, {78, -16}}), Rectangle(extent = {{-88, 10}, {-60, -4}}), Polygon(points = {{-60, 18}, {-34, 4}, {-60, -10}, {-60, 18}}), Text(lineColor = {0, 0, 127}, extent = {{-60, -78}, {-102, -46}}, textString = "U"), Text(origin = {0, -4}, lineColor = {0, 0, 127}, extent = {{-62, 48}, {-98, 78}}, textString = "W")}),
    Documentation(info = "<html>
<p>This class produces a three-phase voltage system to variable-frequency control of an asynchronous motor.</p>
<p>The output voltages constitute a three-phase system of quasi-sinusoidal shapes, created according to the following equations:</p>
<p>Wel=Wmecc*PolePairs+DeltaWel</p>
<p>U=U0+(Un-U0)*(Wel)/Wnom</p>
<p>where:</p>
<p><ul>
<li>U0, Un U, are initial, nominal actual voltage amplitudes</li>
<li>Wmecc, Wel are machine (mechanical) and supply (electrical) angular speeds</li>
<li>PolePairs are the number of machine pole pairs</li>
<li>DeltaWel is an input variable and depends on the desired torque</li>
</ul></p>
</html>"));
end GenSines;
