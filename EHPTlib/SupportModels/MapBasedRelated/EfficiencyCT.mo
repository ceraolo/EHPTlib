within EHPTlib.SupportModels.MapBasedRelated;
block EfficiencyCT
  "Determines the electric power from the mechanical from a Combi-Table efficiency map"
  parameter Boolean mapsOnFile = false;
  parameter Modelica.Units.SI.Torque tauMax(start=400)
    "Maximum machine torque";
  parameter Modelica.Units.SI.Power powMax(start=22000)
    "Maximum drive power";
  parameter Modelica.Units.SI.AngularVelocity wMax(start=650)
    "Maximum machine speed";
  parameter String mapsFileName = "NoName" "File where matrix is stored" annotation (
    Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
  parameter String effTableName = "noName" "name of the on-file efficiency matrix" annotation (
    Dialog(enable = mapsOnFile));
  parameter Real effTable[:, :] = [0.00, 0.00, 0.25, 0.50, 0.75, 1.00; 0.00, 0.75, 0.80, 0.81, 0.82, 0.83; 0.25, 0.76, 0.81, 0.82, 0.83, 0.84; 0.50, 0.77, 0.82, 0.83, 0.84, 0.85; 0.75, 0.78, 0.83, 0.84, 0.85, 0.87; 1.00, 0.80, 0.84, 0.85, 0.86, 0.88] annotation (
    Dialog(enable = not mapsOnFile));
  //the name is passed because a file can contain efficiency tables for
  //different submodels, e.g. genEfficiency for generator and motEfficiency for motor.
  Modelica.Blocks.Tables.CombiTable2Ds toEff(
    tableOnFile=mapsOnFile,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=mapsFileName,
    tableName=effTableName,
    table=effTable,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
                    "normalised efficiency" annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={22,-20})));
  Modelica.Blocks.Interfaces.RealInput w annotation (
    Placement(transformation(extent = {{-140, -60}, {-100, -20}}), iconTransformation(extent = {{-140, -60}, {-100, -20}})));
  Modelica.Blocks.Interfaces.RealInput tau annotation (
    Placement(transformation(extent = {{-140, 20}, {-100, 60}}), iconTransformation(extent = {{-140, 20}, {-100, 60}})));
  Modelica.Blocks.Interfaces.RealOutput elePow( unit="W") annotation (
    Placement(transformation(extent = {{96, -10}, {116, 10}})));
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(transformation(extent = {{-76, -50}, {-56, -30}})));
  Modelica.Blocks.Math.Abs abs2 annotation (
    Placement(transformation(extent = {{-80, 40}, {-60, 60}})));
  Modelica.Blocks.Math.Gain normalizeTau(k = 1 / tauMax) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-36, 50})));
  SupportModels.MapBasedRelated.Pel applyEta annotation (
    Placement(transformation(extent = {{60, -10}, {84, 12}})));
  Modelica.Blocks.Math.Product toPmot
    annotation (Placement(transformation(extent={{-72,0},{-52,20}})));
  Modelica.Blocks.Math.Gain normalizeSpeed(k = 1 / wMax) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-34, -40})));
equation
  connect(tau, abs2.u) annotation (
    Line(points = {{-120, 40}, {-94, 40}, {-94, 50}, {-82, 50}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(w, abs1.u) annotation (
    Line(points = {{-120, -40}, {-78, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(abs2.y, normalizeTau.u) annotation (
    Line(points = {{-59, 50}, {-48, 50}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(normalizeTau.y, toEff.u1) annotation (Line(
      points={{-25,50},{-18,50},{-18,-12.8},{7.6,-12.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(applyEta.Pel, elePow) annotation (
    Line(points = {{85.2, 1}, {92.48, 1}, {92.48, 0}, {106, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(toEff.y, applyEta.eta) annotation (Line(
      points={{35.2,-20},{48,-20},{48,-5.6},{57.6,-5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toPmot.u1, tau) annotation (Line(
      points={{-74,16},{-84,16},{-84,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toPmot.u2, w) annotation (Line(
      points={{-74,4},{-84,4},{-84,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toPmot.y, applyEta.P) annotation (Line(
      points={{-51,10},{42,10},{42,7.6},{57.6,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs1.y, normalizeSpeed.u) annotation (
    Line(points = {{-55, -40}, {-46, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(normalizeSpeed.y, toEff.u2) annotation (Line(
      points={{-23,-40},{-2,-40},{-2,-27.2},{7.6,-27.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 72}, {100, -72}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-74, -54}, {-74, 58}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-82, -48}, {78, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-74, 38}, {-24, 38}, {-4, 12}, {28, -8}, {60, -22}, {62, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{-20, 14}, {-40, 24}, {-56, -4}, {-38, -36}, {12, -38}, {26, -28}, {22, -20}, {8, -6}, {-8, 4}, {-20, 14}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-28, 4}, {-38, 2}, {-32, -20}, {0, -32}, {10, -28}, {12, -20}, {-28, 4}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-102, 118}, {100, 78}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Text(extent={{-2,54},
              {86,20}},                                                                                                                                                                                                        lineColor={0,0,0},
          textString="CT")}),
    Documentation(info = "<html>
<p>This block computes the machine and inverter losses from the mechanical input quantities and determines the power to be drawn from the electric circuit. The &QUOT;drawn&QUOT; power can be also a negative numer, meaning that themachine is actually delivering electric power.</p>
<p>The given efficiency map is intended as being built with torques being ratios of actual torques to tauMax and speeds being ratios of w to wMax. In case the user uses, in the given efficiency map, torques in Nm and speeds in rad/s, the block can be used selecting tauTmax=1, wMax=1.</p>
<p>The choice of having normalised efficiency computation allows simulations of machines different in sizes and similar in characteristics to be repeated without having to rebuild the efficiency maps. </p>
<p>Torques are written in the first matrix column, speeds on the first row.</p>
</html>"));
end EfficiencyCT;
