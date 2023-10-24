within EHPTlib.MapBased;
model IceT01 "Simple  map-based ice model with connector"
  import Modelica.Constants.*;
  extends Partial.PartialIce(toLimTau(table = maxIceTau, tableOnFile = tablesOnFile, tableName = "maxIceTau", fileName = mapsFileName), toSpecCons(tableOnFile = tablesOnFile, fileName = mapsFileName, tableName = "specificCons"));
  Modelica.Blocks.Interfaces.RealInput nTauRef "normalized torque request" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -100}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -100})));
  Modelica.Blocks.Interfaces.RealOutput fuelCons "Fuel consumption (g/h)" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {60, -90})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-60, -16})));
  Modelica.Blocks.Math.Product product annotation (
    Placement(transformation(extent = {{-48, 50}, {-28, 70}})));
equation
  connect(toG_perHour.y, fuelCons) annotation (
    Line(points = {{30, -61}, {30, -62}, {30, -62}, {30, -62}, {30, -70}, {60, -70}, {60, -90}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(limiter.u, nTauRef) annotation (
    Line(points = {{-60, -28}, {-60, -100}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(Tice.tau, product.y) annotation (
    Line(points = {{-14, 60}, {-27, 60}}, color = {0, 0, 127}));
  connect(product.u2, limiter.y) annotation (
    Line(points = {{-50, 54}, {-60, 54}, {-60, 52}, {-60, -5}}, color = {0, 0, 127}));
  connect(product.u1, toLimTau.y[1]) annotation (
    Line(points = {{-50, 66}, {-58, 66}, {-58, 66}, {-61, 66}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model belongs to the map-based models of power train components.</p>
<p>It models an Internal Combustion Engine, neglecting any dynamics except that related with its rotor inertia.</p>
<p>The input signal is a normalised request (0..1). </p>
<p>The generated torque is the product of the maximum deliverable torque at the actual engine speed, defined by means of a table, and the normalised input signal.</p>
<p>The fuel consumption is computed from the generated torque and speed.</p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(extent = {{-100, -40}, {-20, -70}}, lineColor = {0, 0, 127}, textString = "0..1")}));
end IceT01;
