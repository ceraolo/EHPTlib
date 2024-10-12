partial model PartialIceTNm "Partial map-based ice model"
  import Modelica.Constants.*;
  extends PartialIceBase;
  parameter Real contrGain(unit = "N.m/W") = 0.1 "Proportional controller gain" annotation(
    Dialog(group = "General parameters"));
  parameter Modelica.Units.SI.AngularVelocity wIceStart = 167;
  parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
    Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
  parameter String specConsName = "NoName" "name of the on-file specific consumption variable" annotation(
    Dialog(enable = mapsOnFile));
  Modelica.Blocks.Tables.CombiTable1Dv toLimTau(table = maxIceTau, tableOnFile = mapsOnFile, tableName = "maxIceTau", fileName = mapsFileName) annotation(
    Placement(visible = true, transformation(origin = {-60, 44}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression rotorW(y = wSensor.w) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-76, -8})));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(transformation(extent = {{-34, 68}, {-14, 88}})));
  SupportModels.Miscellaneous.Gain toPuSpeed1(k = 1/nomSpeed) annotation(
    Placement(visible = true, transformation(origin = {-76, 20}, extent = {{6, -6}, {-6, 6}}, rotation = -90)));
  SupportModels.Miscellaneous.Gain fromPuTorque(k = nomTorque) annotation(
    Placement(visible = true, transformation(origin = {-48, 72}, extent = {{6, -6}, {-6, 6}}, rotation = 180)));
equation 
  connect(min1.y, iceTau.tau) annotation(
    Line(points = {{-13, 78}, {2, 78}}, color = {0, 0, 127}));
  connect(toPuSpeed1.y, toLimTau.u[1]) annotation(
    Line(points = {{-76, 26.6}, {-76, 44}, {-72, 44}}, color = {0, 0, 127}));
  connect(toPuSpeed1.u, rotorW.y) annotation(
    Line(points = {{-76, 12.8}, {-76, 3}}, color = {0, 0, 127}));
  connect(fromPuTorque.y, min1.u2) annotation(
    Line(points = {{-41.4, 72}, {-36, 72}}, color = {0, 0, 127}));
  connect(fromPuTorque.u, toLimTau.y[1]) annotation(
    Line(points = {{-55.2, 72}, {-68, 72}, {-68, 58}, {-40, 58}, {-40, 44}, {-49, 44}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial ICE model with torque input in Newton-metres. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- partialIceP that contains an in ternal loop so that the request from the exterior is now in power instead of torque</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceP used when ICE must follow a Power request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnP used when ICE must follow a Power request through an expandable connector</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnPOO used when ICE must follow a Power request through an expandable connector, and also ON7Off can be commanded from the outside</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT used when ICE must follow a Torque request </span></p>
<p><span style=\"font-family: Arial;\">See their documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</span></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false), graphics = {Line(points = {{-50, 84}, {-36, 84}}, color = {255, 0, 0})}));
end PartialIceTNm;
