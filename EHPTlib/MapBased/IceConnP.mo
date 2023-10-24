within EHPTlib.MapBased;
model IceConnP "Simple map-based ice model with connector; follows power request"
  extends Partial.PartialMBiceP;
  import Modelica.Constants.*;
  parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent = {{-20, -82}, {20, -122}}, rotation = 0), iconTransformation(extent = {{-20, -82}, {20, -122}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator toKgFuel(k = 1 / 3.6e6) annotation (
    Placement(visible = true, transformation(origin = {24, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(toKgFuel.u, toG_perHour.y) annotation (
    Line(points = {{24, -68}, {24, -61}}, color = {0, 0, 127}));
  connect(feedback.u1, conn.icePowRef) annotation (
    Line(points = {{-88, 52}, {-88, 52}, {-88, -102}, {0, -102}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(Pice.power, conn.icePowDel) annotation (
    Line(points = {{68, 63}, {68, 63}, {68, 6}, {78, 6}, {78, -102}, {0, -102}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(w.w, conn.iceW) annotation (
    Line(points = {{56, 25}, {58, 25}, {58, 6}, {58, -102}, {0, -102}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 80}}, initialScale = 0.1)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</span></b> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is a variation of model IceT, having the following differences:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- it follows a reference power instead of a reference torque</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- it is connected to the outside through an exapandable conecctor.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Connector signals:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowRef (input) is the power request (W). Negative values are internally converted to zero</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- iceW (output) is the measured ICE speed (rad/s)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowDel (output) delivered power (W)</span></p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})));
end IceConnP;
