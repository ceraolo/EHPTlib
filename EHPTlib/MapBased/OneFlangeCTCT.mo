within EHPTlib.MapBased;
model OneFlangeCTCT "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlangeCTCT;

  Modelica.Blocks.Interfaces.RealInput tauRef annotation (Placement(
        transformation(extent={{-138,-90},{-98,-50}}), iconTransformation(
          extent={{-138,-20},{-98,20}})));
equation
  connect(tauRef, variableLimiter.u) annotation (Line(points={{-118,-70},{0,-70},
          {0,28},{-8,28},{-8,30},{-14,30}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>This is a model that models an electric drive: electronic converter + electric machine.</p>
<p>The only model dynamics is its inertia. </p>
<p>The input signal is a torque request (Nm), which is applied to a mechanical inertia. </p>
<p>The maximum available torque is internally computed considering a direct torque maximum (tauMax) and a power maximum (powMax); the model then computes the inner losses and absorbs the total power from the DC input.</p>
<p>Note that to evaluate the inner losses the model uses an efficiency map (i.e. a table), in which torques are ratios of actual torques to tauMax and speeds are ratios of w to wMax. Because of this wMax must be supplied as a parameter.</p>
<p>Improvement onto OneFlange: now the user can implement max and minimum torque as a function of the angular speed, through curves supplied via an array taken from an input file: CTCT in the name means that both the maxiomum torque and the efficiency evaluation are CombiTable based.</p>
<p>This model is not parameter-compatible with OneFlange. This has caused this new model to be introduced. </p>
</html>"),
    Diagram(coordinateSystem(                                     preserveAspectRatio=false)),
    Icon(coordinateSystem(                                    preserveAspectRatio=false)));
end OneFlangeCTCT;
