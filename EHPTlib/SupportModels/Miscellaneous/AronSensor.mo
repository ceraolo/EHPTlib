within EHPTlib.SupportModels.Miscellaneous;
model AronSensor "Two port three-phase power sensor"
  Modelica.Electrical.Polyphase.Interfaces.PositivePlug pc
    "Positive plug, current path" annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,
            -10},{-90,10}})));
  Modelica.Electrical.Polyphase.Interfaces.NegativePlug nc(final m=3)
    "Negative plug, current path" annotation (Placement(transformation(
          extent={{90,12},{110,-8}}, rotation=0), iconTransformation(
          extent={{90,10},{110,-10}})));
  Modelica.Blocks.Interfaces.RealOutput y(final unit = "W") annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-20, -110})));
equation
  for ph in 1:3 loop
    pc.pin[ph].i + nc.pin[ph].i = 0;
    pc.pin[ph].v = nc.pin[ph].v;
  end for;
  //Aron formula for power (common wire is wire 2):
  y = pc.pin[1].i * (pc.pin[1].v - pc.pin[2].v) + pc.pin[3].i * (pc.pin[3].v - pc.pin[2].v);
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Line(points = {{-104, 0}, {96, 0}}, color = {0, 0, 255}), Ellipse(extent = {{-70, 70}, {70, -70}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{0, 70}, {0, 40}}, color = {0, 0, 0}), Line(points = {{22.9, 32.8}, {40.2, 57.3}}, color = {0, 0, 0}), Line(points = {{-22.9, 32.8}, {-40.2, 57.3}}, color = {0, 0, 0}), Line(points = {{37.6, 13.7}, {65.8, 23.9}}, color = {0, 0, 0}), Line(points = {{-37.6, 13.7}, {-65.8, 23.9}}, color = {0, 0, 0}), Line(points = {{0, 0}, {9.02, 28.6}}, color = {0, 0, 0}), Polygon(points = {{-0.48, 31.6}, {18, 26}, {18, 57.2}, {-0.48, 31.6}}, lineColor = {0, 0, 0}, fillColor = {0, 0, 0}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-5, 5}, {5, -5}}, lineColor = {0, 0, 0}, fillColor = {0, 0, 0}, fillPattern = FillPattern.Solid), Text(extent = {{-39, -3}, {40, -66}}, lineColor = {0, 0, 0}, textString = "P3"), Line(points = {{-20, -104}, {-20, -66}}, color = {0, 0, 127}, smooth = Smooth.None), Text(origin = {0, 10}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 102}, {100, 62}}, textString = "%name")}),
    Documentation(info = "<html>
<p><code><span style=\"font-family: Courier New,courier;\">&nbsp;Uses the <span style=\"color: #006400;\">Aron&nbsp;formula&nbsp;for&nbsp;power&nbsp;(common&nbsp;wire&nbsp;is&nbsp;wire&nbsp;2):</span></code></p>
<pre><span style=\"font-family: Courier New,courier; color: #006400;\">y=i1*(v1-v2) + i3*(v3-v2)</span></pre>
</html>"));
end AronSensor;
