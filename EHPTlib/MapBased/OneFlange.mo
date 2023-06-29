within EHPTlib.MapBased;
model OneFlange "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlange;
  Modelica.Blocks.Interfaces.RealInput tauRef "(positive when motor peration)" annotation (
    Placement(visible = true, transformation(origin = {-118, -66}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {-114, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(variableLimiter.u, tauRef) annotation (
    Line(points = {{-2, 30}, {14, 30}, {14, -66}, {-118, -66}}, color = {0, 0, 127}));
  annotation (
    Documentation(info = "<html>
<p>This is a model that models an electric drive: electornic converter + electric machine.</p>
<p>The only model dynamics is its inertia. </p>
<p>The input signal is a torque request (Nm). The requested torque is applied to a mechanical inertia. </p>
<p>The maximum available torque is internally computed considering a direct torque maximum (tauMax) and a power maximum (powMax) </p>
<p>The model then computes the inner losses and absorbs the total power from the DC input.</p>
<p>Note that to evaluate the inner losses the model uses an efficiency map (i.e. a table), in which torques are ratios of actual torques to tauMax and speeds are ratios of w to wMax. Because of this wMax must be supplied as a parameter.</p>
</html>"),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-100, -80}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1)));
end OneFlange;
