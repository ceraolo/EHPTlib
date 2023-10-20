within EHPTlib.SupportModels.Miscellaneous;
model Batt1Conn
  extends Batt1;
  Modelica.Blocks.Sources.RealExpression SOCs(y=SOC)   annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin={-82,-8})));
  Modelica.Blocks.Sources.RealExpression outPow(y=(p.v - n.v)*n.i)     annotation (
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = -90, origin={-82,-64})));
  ConnectorRelated.Conn                       conn annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-102,-40})));
equation
  connect(conn.batSOC,SOCs. y) annotation (
    Line(points={{-102,-40},{-102,-29.5},{-82,-29.5},{-82,-19}},    color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None),
    Text(string = "%first", index = -1, extent = {{-6, 3}, {-6, 3}}));
  connect(outPow.y,conn. batPowDel) annotation (
    Line(points={{-82,-53},{-82,-40},{-102,-40}},      color = {0, 0, 127}, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Similar to Batt1, but with expandable connector. Output signals:</p>
<p>- state-of-charge &quot;batSOC&quot;</p>
<p>- outputted power &quot;batPowDel&quot;.</p>
</html>"));
end Batt1Conn;
