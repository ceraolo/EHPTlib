within EHPTlib.MapBased;
model IceT
  extends Partial.PartialIceTNm;
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=0, uMax=1e99)     annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin={-80,-56})));
  Modelica.Blocks.Interfaces.RealInput tauRef "torque request (positive when motor)" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin={-60,-122}),    iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin={-60,-118})));
  Modelica.Blocks.Sources.BooleanConstant onSignal
    annotation (Placement(transformation(extent={{-50,-60},{-34,-44}})));
equation
  connect(min1.u1, limiter.y) annotation (Line(points={{-36,84},{-92,84},{-92,
          -40},{-80,-40},{-80,-45}}, color={0,0,127}));
  connect(limiter.u, tauRef)
    annotation (Line(points={{-80,-68},{-80,-96},{-60,-96},{-60,-122}},
                                                    color={0,0,127}));
  connect(onSignal.y, switch1.u2) annotation (Line(points={{-33.2,-52},{-18,-52},
          {-18,-52},{-4,-52}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-88,-58},{-34,-90}},
          textColor={162,29,33},
          textStyle={TextStyle.Bold,TextStyle.Italic},
          textString="T")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model extends PartialIce0, and just adds an input torque which is the reference ICE is required to follow.</p>
</html>"));
end IceT;
