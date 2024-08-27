within EHPTlib.MapBased;
model OneFlangeCTLF "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlangeCTLF;

  Modelica.Blocks.Interfaces.RealInput tauRef annotation (Placement(
        transformation(extent={{-138,-90},{-98,-50}}), iconTransformation(
          extent={{-138,-20},{-98,20}})));
equation
  connect(variableLimiter.u, tauRef) annotation (Line(points={{-14,30},{0,30},{
          0,-70},{-118,-70}}, color={0,0,127}));
end OneFlangeCTLF;
