within EHPTlib.SupportModels.ConnectorRelated;
model ToConnGenTauRef "Signal adaptor to send genTauRef to a connector"
  Modelica.Blocks.Interfaces.RealInput u annotation (
    Placement(transformation(extent = {{-90, -20}, {-50, 20}}), iconTransformation(extent = {{-90, -20}, {-50, 20}})));
  Conn conn annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {58, 0}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {58, 0})));
equation
  connect(u, conn.genTauRef) annotation (
    Line(points = {{-70, 0}, {58, 0}}, color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -60}, {60, 60}}), graphics={  Rectangle(extent = {{-60, 40}, {60, -40}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-40, 0}, {32, 0}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{42, 0}, {22, 8}, {22, -8}, {42, 0}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {0, 0, 0}, fillPattern = FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -60}, {60, 60}}), graphics),
    Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Adapter for an input signal into &QUOT;genTauRef&QUOT; signal in the library connector.</span></p>
</html>"));
end ToConnGenTauRef;
