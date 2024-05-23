within EHPTlib.MapBased;
model IceT
  extends Partial.PartialIce0;
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=0, uMax=1e99)     annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin={-60,-56})));
  Modelica.Blocks.Interfaces.RealInput tauRef "torque request (positive when motor)" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin={-60,-122}),    iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -100})));
equation
  connect(min1.u1, limiter.y) annotation (Line(points={{-36,58},{-92,58},{-92,
          -40},{-60,-40},{-60,-45}}, color={0,0,127}));
  connect(limiter.u, tauRef)
    annotation (Line(points={{-60,-68},{-60,-122}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model extends PartialIce0, and just adds an input torque which is the reference ICE is required to follow.</p>
</html>"));
end IceT;
