within EHPTlib.SupportModels.MapBasedRelated;
model InertiaTq "Inertia with added torque"
  import      Modelica.Units.SI;
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation (
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation (
    Placement(transformation(extent = {{90, -10}, {110, 10}}, rotation = 0)));
  parameter SI.Inertia J(min = 0, start = 1) "Moment of inertia";
  parameter StateSelect stateSelect = StateSelect.default "Priority to use phi and w as states" annotation (
    HideResult = true,
    Dialog(tab = "Advanced"));
  SI.Angle phi(stateSelect = stateSelect) "Absolute rotation angle of component" annotation (
    Dialog(group = "Initialization", showStartAttribute = true));
  SI.AngularVelocity w(stateSelect = stateSelect) "Absolute angular velocity of component (= der(phi))" annotation (
    Dialog(group = "Initialization", showStartAttribute = true));
  SI.AngularAcceleration a "Absolute angular acceleration of component (= der(w))" annotation (
    Dialog(group = "Initialization", showStartAttribute = true));
  Modelica.Blocks.Interfaces.RealInput tau annotation (
    Placement(transformation(extent = {{-20.5, -20}, {20.5, 20}}, rotation = 90, origin = {-54.5, -100})));
equation
  phi = flange_a.phi;
  phi = flange_b.phi;
  w = der(phi);
  a = der(w);
  J * a = flange_a.tau + flange_b.tau + tau;
  annotation (
    Documentation(info = "<html>
    <p>
    Rotational component with <b>inertia</b> and two rigidly connected flanges.
    </p>

    </HTML>
    "),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics={  Rectangle(extent = {{-100, 10}, {-50, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{50, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Line(points = {{-80, -25}, {-60, -25}}, color = {0, 0, 0}), Line(points = {{60, -25}, {80, -25}}, color = {0, 0, 0}), Line(points = {{-70, -25}, {-70, -70}}, color = {0, 0, 0}), Line(points = {{70, -25}, {70, -70}}, color = {0, 0, 0}), Line(points = {{-80, 25}, {-60, 25}}, color = {0, 0, 0}), Line(points = {{60, 25}, {80, 25}}, color = {0, 0, 0}), Line(points = {{-70, 45}, {-70, 25}}, color = {0, 0, 0}), Line(points = {{70, 45}, {70, 25}}, color = {0, 0, 0}), Line(points = {{-70, -70}, {70, -70}}, color = {0, 0, 0}), Rectangle(extent = {{-50, 50}, {50, -50}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Text(extent = {{-150, 100}, {150, 60}}, textString = "%name", lineColor = {0, 0, 255}), Text(extent = {{-150, -80}, {150, -120}}, lineColor = {0, 0, 0}, textString = "J=%J")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics));
end InertiaTq;
