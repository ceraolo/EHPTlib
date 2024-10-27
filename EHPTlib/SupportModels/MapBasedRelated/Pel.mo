within EHPTlib.SupportModels.MapBasedRelated;

block Pel "Outputs a power signal computed from the given efficiency and input power"
  Modelica.Blocks.Interfaces.RealInput eta "efficiency" annotation(
    Placement(transformation(extent = {{-140, -80}, {-100, -40}}), iconTransformation(extent = {{-140, -80}, {-100, -40}})));
  Modelica.Blocks.Interfaces.RealInput P "Delivered Mechanical Power" annotation(
    Placement(transformation(extent = {{-140, 40}, {-100, 80}}), iconTransformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealOutput Pel "Absorbed Electrical power" annotation(
    Placement(transformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Units.SI.Power Losses = abs(Pel - P);
algorithm
  if noEvent(P <= 0) then
    Pel := P*eta;
  else
    Pel := P/eta;
  end if;
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-78, 82}, {70, -92}}, lineColor = {0, 0, 127}, fillColor = {170, 255, 255}, fillPattern = FillPattern.Solid, textString = "Pmecc
to
Pel"), Text(extent = {{-102, 144}, {104, 110}}, textColor = {0, 0, 255}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics),
    Documentation(info = "<html>
<pre><span style=\"font-family: Courier New,courier;\">Outputs&nbsp;a power signal computed from the&nbsp;given&nbsp;efficiency&nbsp;and&nbsp;input&nbsp;power</span></pre>
</html>"));
end Pel;
