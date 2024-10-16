within EHPTlib.MapBased;
model IceConnP
  "Simple map-based ice model with connector; follows power request"
  extends Partial.PartialIceP;
  import Modelica.Constants.*;
  parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent = {{-20, -82}, {20, -122}}, rotation = 0), iconTransformation(extent = {{-20, -82}, {20, -122}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant onSignal
    annotation (Placement(transformation(extent={{-54,-60},{-38,-44}})));
equation
  connect(feedback.u1, conn.icePowRef) annotation (
    Line(points={{-110,58},{-118,58},{-118,-94},{0,-94},{0,-102}},color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(icePow.power, conn.icePowDel) annotation (Line(points={{68,89},{68,89},
          {68,6},{78,6},{78,-102},{0,-102}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(wSensor.w, conn.iceW) annotation (Line(points={{58,51},{58,51},{58,6},
          {58,-102},{0,-102}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(onSignal.y, switch1.u2)
    annotation (Line(points={{-37.2,-52},{-4,-52}}, color={255,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</span></b> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is a variation of model IceT, having the following differences:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- it follows a reference power instead of a reference torque (that justifies &quot;P&quot; in the name instead of &quot;T&quot;)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- it is connected to the outside through an exapandable connector (&quot;Conn&quot; in the name).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Connector signals:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowRef (input) is the power request (W). Negative values are internally converted to zero</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- iceW (output) is the measured ICE speed (rad/s)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowDel (output) delivered power (W)</span></p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})));
end IceConnP;
