within EHPTlib.MapBased;
model IceT01 "Simple  map-based ice model with connector"
  import Modelica.Constants.*;
  extends Partial.PartialIceT01(toLimTau(table = maxIceTau, tableOnFile = mapsOnFile,
      tableName = "maxIceTau", fileName = mapsFileName), toGramsPerkWh(tableOnFile = mapsOnFile,
      fileName = mapsFileName, tableName = specConsName));
  Modelica.Blocks.Interfaces.RealOutput fuelCons "Fuel consumption (g/h)" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin={60,-98}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-98})));
  Modelica.Blocks.Sources.BooleanConstant onSignal
    annotation (Placement(transformation(extent={{-46,-60},{-30,-44}})));
equation
  connect(toG_perHour.y, fuelCons) annotation (
    Line(points={{38,-51},{38,-56},{60,-56},{60,-98}},                                           color = {0, 0, 127}, smooth = Smooth.None));
  connect(switch1.u2, onSignal.y)
    annotation (Line(points={{-4,-52},{-29.2,-52}}, color={255,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model belongs to the map-based models of power train components.</p>
<p>It models an Internal Combustion Engine, neglecting any dynamics except that related with its rotor inertia.</p>
<p>The input signal is a normalised request (0..1). </p>
<p>The generated torque is the product of the maximum deliverable torque at the actual engine speed, defined by means of a table, and the normalised input signal.</p>
<p>The fuel consumption is computed from the generated torque and speed.</p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(extent={{-100,
              -48},{-20,-78}},                                                                                                                                                       lineColor = {0, 0, 127}, textString = "0..1")}));
end IceT01;
