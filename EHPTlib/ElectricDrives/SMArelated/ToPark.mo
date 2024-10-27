within EHPTlib.ElectricDrives.SMArelated;
model ToPark "Semplice PMM con modello funzionale inverter"
  parameter Integer p "number of pole pairs";
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator annotation (
    Placement(transformation(extent = {{0, 0}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y[2] annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}}), iconTransformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Blocks.Interfaces.RealInput X[3] annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealInput phi annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {10, -110}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {0, -120})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasor annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-30, 10})));
  Modelica.Blocks.Math.Gain gain(k = p) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {10, -42})));
equation
  connect(toSpacePhasor.y, rotator.u) annotation (
    Line(points = {{-19, 10}, {-2, 10}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(rotator.y, y) annotation (
    Line(points = {{21, 10}, {66, 10}, {66, 0}, {110, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(toSpacePhasor.u, X) annotation (
    Line(points = {{-42, 10}, {-82, 10}, {-82, 0}, {-120, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(gain.y, rotator.angle) annotation (
    Line(points = {{10, -31}, {10, -2}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(gain.u, phi) annotation (
    Line(points = {{10, -54}, {10, -110}}, color = {0, 0, 127}, smooth = Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics),
    Documentation(info = "<html><head></head><body><p>Converts phase values to Park' direct-quadruature components assuming null zero component, and can be used to convert any quantity, e.g. currents. voltages, etc.</p><i>
</i></body></html>"),
    __Dymola_experimentSetupOutput,
    Icon(graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127},
                fillColor={255,255,255},fillPattern=FillPattern.Solid),
          Text( extent={{-96,32},{96,-22}},
                lineColor={0,0,127},
                textString="=>P"),Text(
                extent={{-106,144},{104,106}},
                lineColor={0,0,255},
                textString="%name")}));
end ToPark;
