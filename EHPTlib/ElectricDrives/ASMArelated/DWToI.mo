within EHPTlib.ElectricDrives.ASMArelated;
model DWToI "Delta Omega to I"
  // follows eq. 12.13 from FEPE Book
  parameter Modelica.Units.SI.Resistance Rr
    "rotor resistance in stato units";
  parameter Integer pp "pole pairs";
  parameter Real Kw "constant Komega of FEPE Book";
  parameter Modelica.Units.SI.Current iMax "maximum calue of rms current";
  parameter Modelica.Units.SI.Inductance Lstray
    "combined stray inductance";
  Modelica.Units.SI.Current I "current before limitation";
  Modelica.Blocks.Interfaces.RealInput u annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Blocks.Sources.RealExpression I_(y = I) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = iMax, uMin = 0) annotation (
    Placement(transformation(extent = {{42, -10}, {62, 10}})));
equation
  I = sqrt(u ^ 2 * Kw ^ 2 / ((pp * u * Lstray) ^ 2 + Rr ^ 2));
  connect(I_.y, limiter.u) annotation (
    Line(points = {{11, 0}, {26, 0}, {40, 0}}, color = {0, 0, 127}));
  connect(y, limiter.y) annotation (
    Line(points = {{110, 0}, {86, 0}, {63, 0}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -40}, {100, 40}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-62, -62}, {-62, 64}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-70, 54}, {-62, 66}, {-56, 54}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-76, -54}, {68, -54}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-7, -6}, {1, 6}, {7, -6}}, color = {0, 0, 127}, smooth = Smooth.None, origin = {65, -54}, rotation = 270), Line(points = {{-68, -62}, {2, 28}, {54, 28}}, color = {0, 0, 127}, smooth = Smooth.None), Text(extent = {{-50, 68}, {-14, 40}}, lineColor = {0, 0, 127}, textString = "I"), Line(points = {{-69, 27}, {-53, 27}}, color = {0, 0, 127}, smooth = Smooth.None), Text(extent = {{-100, 144}, {98, 106}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name")}),
    __OpenModelica_commandLineOptions = "");
end DWToI;
