within EHPTlib.MapBased;
model IceT "Simple  map-based ice model with connector"
  import Modelica.Constants.*;
  extends Partial.PartialIce;
  parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
  // rad/s
  Modelica.Blocks.Interfaces.RealInput tauRef "torque request (positive when motor)" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -100}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -100})));
  Modelica.Blocks.Interfaces.RealOutput fuelCons "Fuel consumption (g/h)" annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {60, -90})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1e99) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-60, -16})));
  Modelica.Blocks.Math.Min min annotation (
    Placement(transformation(extent = {{-48, 50}, {-28, 70}})));
equation
  connect(toG_perHour.y, fuelCons) annotation (
    Line(points = {{30, -61}, {30, -61}, {26, -61}, {60, -61}, {60, -90}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(limiter.u, tauRef) annotation (
    Line(points = {{-60, -28}, {-60, -100}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(min.u1, toLimTau.y[1]) annotation (
    Line(points = {{-50, 66}, {-58, 66}, {-61, 66}}, color = {0, 0, 127}));
  connect(min.u2, limiter.y) annotation (
    Line(points = {{-50, 54}, {-60, 54}, {-60, -5}}, color = {0, 0, 127}));
  connect(min.y, Tice.tau) annotation (
    Line(points = {{-27, 60}, {-21.5, 60}, {-14, 60}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model belongs to the map-based models of power train components.</p>
<p>It models an Internal Combustion Engine, neglecting any dynamics except that related with its rotor inertia.</p>
<p>The input signal is the torque request (Nm). </p>
<p>The generated torque is the minimum between this signal (negative values are transformed to 0) and the maximum deliverable torque at the actual engine speed, defined by means of a table.</p>
<p>The fuel consumption is computed from the generated torque and speed. </p>
<p>Compare ICE input tau and internal Tice.tau.</p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(extent = {{-100, -44}, {-22, -72}}, lineColor = {0, 0, 127}, textString = "Nm")}));
end IceT;
