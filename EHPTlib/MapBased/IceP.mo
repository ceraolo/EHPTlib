within EHPTlib.MapBased;
model IceP "Extends PartialIce0 adding power input"
  extends Partial.PartialIceP;

  Modelica.Blocks.Interfaces.RealInput powRef "torque request (positive when motor)" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin={-88,-120}),    iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin={-60,-120})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=0, uMax=1e99)     annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin={-88,-36})));
  Modelica.Blocks.Sources.BooleanConstant onSignal
    annotation (Placement(transformation(extent={{-52,-60},{-36,-44}})));
equation
  connect(limiter.u, powRef)
    annotation (Line(points={{-88,-48},{-88,-120}}, color={0,0,127}));
  connect(limiter.y, feedback.u1) annotation (Line(points={{-88,-25},{-88,24},{
          -104,24},{-104,58},{-92,58}}, color={0,0,127}));
  connect(onSignal.y, switch1.u2)
    annotation (Line(points={{-35.2,-52},{-4,-52}}, color={255,0,255}));
  annotation (
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basic partial ICE model. Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT used when ICE must follow a Torque request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceP used when ICE must follow a Power request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnP used when ICE must follow a Power request trhough an expandable connector</span></p>
<p>Data for tables (here called &quot;maps&quot;) can be set manually or loaded from a file.</p>
<h4>Inherited models connect torque request to the free input of min() block.</h4>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Rectangle(fillColor = {192, 192, 192},
      fillPattern = FillPattern.HorizontalCylinder, extent = {{-24, 48}, {76, -44}}), Rectangle(fillColor = {192, 192, 192},
      fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}),                                                                                                                                 Text(origin = {0, 10}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95},
      fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135},
      fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
    Diagram(coordinateSystem(extent={{-120,-100},{100,80}},     preserveAspectRatio=false)));
end IceP;
