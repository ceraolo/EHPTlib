within EHPTlib.MapBased;

model TwoFlange "Simple map-based two-flange electric drive model"
  extends Partial.PartialTwoFlange;
  Modelica.Blocks.Interfaces.RealInput tauRef annotation(
    Placement(transformation(origin = {0, -114}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -102}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
equation
  connect(torqueLimiter.u, tauRef) annotation(
    Line(points = {{-18, 2}, {-24, 2}, {-24, -70}, {0, -70}, {0, -114}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 10}, {-66, -10}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{66, 8}, {100, -12}}), Rectangle(origin = {-25, -2}, extent = {{-75, 78}, {125, -78}}), Line(origin = {20, -2}, points = {{-60, 94}, {-60, 76}}, color = {0, 0, 255}), Line(origin = {-20, -2}, points = {{60, 94}, {60, 76}}, color = {0, 0, 255})}),
    Documentation(info = "<html>
<p>This is a model that models an electric drive: electronic converter + electric machine.</p>
<p>The only model dynamics is its inertia. </p>
<p>The input signal is a torque request (Nm). The requested torque is applied to a mechanical inertia. </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model receives from the input connector the torque request and tries to &QUOT;deliver&QUOT; it. Delivering means adding a torque to the system so that the torque exiting from flange B equals the one entering from flange A plus the one requested from the input connector.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This simulates a two-flange electrical machine, where the added torque is the torque produced by the machine magnetic field stator-rotor interaction.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">However, before delivering the requested torque, the model limits it considering the maximum deliverable torque and power. In addition, it computes and considers inner losses as determined by means of a map. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The maximum available torque is internally computed considering a direct torque maximum (tauMax) and a power maximum (powMax) </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The requested torque is applied to a mechancal inertia. The inertia is interfaced by means of two flanges with the exterior.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model then computes the inner losses and absorbs the total power from the DC input.</span></p>
</html>"));
end TwoFlange;
