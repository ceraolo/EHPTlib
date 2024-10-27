within EHPTlib.ElectricDrives.SMArelated;
model FromPark "Semplice PMM con modello funzionale inverter"
  parameter Integer p "Number or pole pairs";
  Modelica.Electrical.Machines.SpacePhasors.Blocks.FromSpacePhasor fromSpacePhasor annotation (
    Placement(transformation(extent = {{60, 0}, {80, 20}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator annotation (
    Placement(transformation(extent = {{0, 6}, {20, 26}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2_1 annotation (
    Placement(transformation(extent = {{-40, 0}, {-20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y[3] annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}}), iconTransformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Blocks.Interfaces.RealInput Xd annotation (
    Placement(transformation(extent = {{-140, 40}, {-100, 80}}), iconTransformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealInput Xq annotation (
    Placement(transformation(extent = {{-140, -80}, {-100, -40}}), iconTransformation(extent = {{-140, -80}, {-100, -40}})));
  Modelica.Blocks.Interfaces.RealInput phi annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {0, -120}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {0, -120})));
  Modelica.Blocks.Math.Gain gain(k = -p) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {10, -50})));
  Modelica.Blocks.Sources.Constant const(k=0)
                                         annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {50, -30})));
equation
  connect(multiplex2_1.y, rotator.u) annotation (
    Line(points = {{-19, 10}, {-10, 10}, {-10, 16}, {-2, 16}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(fromSpacePhasor.u, rotator.y) annotation (
    Line(points = {{58, 10}, {40, 10}, {40, 16}, {21, 16}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(fromSpacePhasor.y, y) annotation (
    Line(points = {{81, 10}, {94, 10}, {94, 0}, {110, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(multiplex2_1.u1[1], Xd) annotation (
    Line(points = {{-42, 16}, {-60, 16}, {-60, 60}, {-120, 60}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(multiplex2_1.u2[1], Xq) annotation (
    Line(points = {{-42, 4}, {-60, 4}, {-60, -60}, {-120, -60}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(rotator.angle, gain.y) annotation (
    Line(points = {{10, 4}, {10, -39}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(gain.u, phi) annotation (
    Line(points = {{10, -62}, {10, -120}, {0, -120}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(fromSpacePhasor.zero, const.y) annotation (
    Line(points = {{58, 2}, {50, 2}, {50, -19}}, color = {0, 0, 127}, smooth = Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><p>Converts from Park' direct-quadruature components to phase values.</p><p>It assumes null zero component, and can be used to convert any quantity, e.g. currents. voltages, etc.</p></body></html>"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}),
        graphics={Rectangle(
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                extent={{-100,100},{100,-100}}),Text(
                lineColor={0,0,127},
                extent={{-96,28},{96,-26}},
                textString="P=>"),Text(
                lineColor={0,0,255},
                extent={{-108,150},{102,110}},
                textString="%name")}));
end FromPark;
