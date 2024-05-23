within EHPTlib.SupportModels.ConnectorRelated;
model ToConnIceON "Signal adaptor to send iceON to a connector"
  Conn conn annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {60, 0}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {60, 0})));
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-100,-20},{-60,20}})));
equation
  connect(u, conn.iceON) annotation (Line(points={{-80,0},{60,0}}, color={255,0,
          255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -60}, {60, 60}}), graphics={  Rectangle(extent = {{-60, 40}, {60, -40}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-38, 0}, {30, 0}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{42, 0}, {22, 8}, {22, -8}, {42, 0}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {0, 0, 0}, fillPattern = FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -60}, {60, 60}})),
    Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Adapter for an input signal into &QUOT;icePowRef&QUOT; signal in the library connector.</span></p>
</html>"));
end ToConnIceON;
