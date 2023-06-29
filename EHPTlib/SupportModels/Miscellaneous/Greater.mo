within EHPTlib.SupportModels.Miscellaneous;
block Greater "Output y is true, if input u1 is greater than input u2"
  extends PartialBooleanComparison;
equation
  y = u1 > u2;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Ellipse(lineColor = {0, 0, 127}, extent = {{32, 10}, {52, -10}}, endAngle = 360), Line(points = {{-100, -80}, {42, -80}, {42, 0}}, color = {0, 0, 127}), Line(points = {{-54, 22}, {-8, 2}, {-54, -18}}, thickness = 0.5), Text(origin = {-20, 133}, lineColor = {0, 0, 255}, extent = {{-96, 25}, {122, -19}}, textString = "%name")}),
    Documentation(info = "<html>
<p>
The output is <b>true</b> if Real input u1 is greater than
Real input u2, otherwise the output is <b>false</b>.
</p>
</html>"));
end Greater;
