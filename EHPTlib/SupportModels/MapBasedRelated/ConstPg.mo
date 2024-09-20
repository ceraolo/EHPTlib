within EHPTlib.SupportModels.MapBasedRelated;
model ConstPg "Constant Power DC Load"
  parameter Modelica.Units.SI.Voltage vNom = 100 "Actual DC voltage should have the same order-of-magnitude of this parameter";
  parameter Modelica.Units.SI.Time Ti=0.01
    "inner PI follower integral time constant";
  Real v "DC voltage";
  Modelica.Blocks.Math.Feedback feedback1 annotation (
    Placement(visible = true, transformation(origin = {56, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(extent = {{-108, 58}, {-88, 78}}, rotation = 0), iconTransformation(extent = {{-10, 90}, {10, 110}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(extent = {{-108, -74}, {-88, -54}}, rotation = 0), iconTransformation(extent = {{-10, -108}, {10, -88}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pref "Reference power" annotation (
    Placement(visible = true, transformation(origin = {100, -44}, extent = {{-18, -18}, {18, 18}}, rotation = 180), iconTransformation(origin = {82, 0}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
  Modelica.Electrical.Analog.Sensors.PowerSensor pSensor annotation (
    Placement(visible = true, transformation(extent = {{-82, 58}, {-62, 78}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.VariableConductor varCond annotation (
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = 1 / vNom ^ 2 / Ti) annotation (
    Placement(visible = true, transformation(origin = {-2, -44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(integrator1.u, feedback1.y) annotation (
    Line(points = {{10, -44}, {47, -44}}, color = {0, 0, 127}));
  connect(integrator1.y, varCond.G) annotation (
    Line(points = {{-13, -44}, {-28, -44}, {-28, 0}, {-39, 0}}, color = {0, 0, 127}));
  connect(feedback1.u2, pSensor.power) annotation (
    Line(points = {{56, -36}, {56, 42}, {-80, 42}, {-80, 57}}, color = {0, 0, 127}));
  connect(varCond.n, pin_n) annotation (
    Line(points = {{-50, -10}, {-50, -10}, {-50, -64}, {-98, -64}, {-98, -64}}, color = {0, 0, 255}));
  connect(varCond.p, pSensor.nc) annotation (
    Line(points = {{-50, 10}, {-50, 10}, {-50, 68}, {-62, 68}, {-62, 68}}, color = {0, 0, 255}));
  connect(pSensor.pv, pSensor.pc) annotation (
    Line(points = {{-72, 78}, {-82, 78}, {-82, 68}}, color = {0, 0, 255}));
  connect(pSensor.pc, pin_p) annotation (
    Line(points = {{-82, 68}, {-98, 68}}, color = {0, 0, 255}));
  connect(pSensor.nv, pin_n) annotation (
    Line(points = {{-72, 58}, {-72, -64}, {-98, -64}}, color = {0, 0, 255}));
  connect(feedback1.u1, Pref) annotation (
    Line(points = {{64, -44}, {100, -44}}, color = {0, 0, 127}));
  v = pin_p.v - pin_n.v;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Line(points = {{-4, 0}, {70, 0}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{0, 94}, {0, -88}, {-2, -90}}, color = {0, 0, 255}, smooth = Smooth.None), Rectangle(extent = {{-28, 68}, {28, -52}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{42, 58}, {78, 22}}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "P")}),
    Documentation(info = "<html><head></head><body><p>This model simulates, following an external reference, a constant-power load.</p><p>It uses a simple integral controller.&nbsp;</p><p>There is no need to state precisely the value of vNom: it only determines the dynamic of the controller. In case the actual DC voltage is exatly equal to vNom, &nbsp;the controller has a dynamics exactly equal to that of a system having as transfer funcrtion G(s)=1 fed by a pure integral controller with time constant equal to Ti.</p><p><br></p>
    </body></html>"));
end ConstPg;
