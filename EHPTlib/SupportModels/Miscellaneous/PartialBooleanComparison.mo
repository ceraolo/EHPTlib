within EHPTlib.SupportModels.Miscellaneous;
partial block PartialBooleanComparison "Partial block with 2 Real input and 1 Boolean output signal (the result of a comparison of the two Real inputs)"
  Modelica.Blocks.Interfaces.RealInput u1 "Connector of first Real input signal" annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Connector of second Real input signal" annotation (
    Placement(transformation(extent = {{-140, -100}, {-100, -60}})));
  Modelica.Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal" annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, lineThickness = 0.5, fillColor = {210, 210, 210}, fillPattern = FillPattern.Solid, borderPattern = BorderPattern.Raised), Ellipse(extent = {{73, 7}, {87, -7}}, lineColor = DynamicSelect({235, 235, 235}, if y > 0.5 then {0, 255, 0} else {235, 235, 235}), fillColor = DynamicSelect({235, 235, 235}, if y > 0.5 then {0, 255, 0} else {235, 235, 235}), fillPattern = FillPattern.Solid), Ellipse(extent = {{32, 10}, {52, -10}}, lineColor = {0, 0, 127}), Line(points = {{-100, -80}, {42, -80}, {42, 0}}, color = {0, 0, 127})}),
    Documentation(info = "<html>
<p>
Block has two continuous Real input and one continuous Boolean output signal
as a result of the comparison of the two input signals. The block
has a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));
end PartialBooleanComparison;
