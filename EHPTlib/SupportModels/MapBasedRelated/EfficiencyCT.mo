within EHPTlib.SupportModels.MapBasedRelated;
block EfficiencyCT
  "Determines the electric power from the mechanical from a Combi-Table efficiency map"
  import Modelica.Constants.pi;
  parameter Boolean mapOnFile = false;/*annotation(choices(checkBox = true))*/
  parameter Real tauFactor=1
    "Factor before inputting torque into map from txt file"
                 annotation(Dialog(enable=mapOnFile));
  parameter Real speedFactor=60/(2*pi)
    "Factor before inputting speed into map from txt file"
                 annotation(Dialog(enable=mapOnFile));
  parameter String mapFileName = "NoName" "File where matrix is stored" annotation (
    Dialog(enable = mapOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
  parameter String effTableName = "noName" "name of the on-file efficiency matrix" annotation (
    Dialog(enable = mapOnFile));
  parameter Real effTable[:, :] = [0.00, 0.00, 0.25, 0.50, 0.75, 1.00; 0.00, 0.75, 0.80, 0.81, 0.82, 0.83; 0.25, 0.76, 0.81, 0.82, 0.83, 0.84; 0.50, 0.77, 0.82, 0.83, 0.84, 0.85; 0.75, 0.78, 0.83, 0.84, 0.85, 0.87; 1.00, 0.80, 0.84, 0.85, 0.86, 0.88] annotation (
    Dialog(enable = not mapOnFile));
  //the name is passed because a file can contain efficiency tables for
  //different submodels, e.g. genEfficiency for generator and motEfficiency for motor.
  Modelica.Blocks.Interfaces.RealInput w annotation (
    Placement(transformation(origin = {28, 0}, extent = {{-140, -60}, {-100, -20}}), iconTransformation(extent = {{-140, -60}, {-100, -20}})));
  Modelica.Blocks.Interfaces.RealInput tau annotation (
    Placement(transformation(origin = {28, 0}, extent = {{-140, 20}, {-100, 60}}), iconTransformation(extent = {{-140, 20}, {-100, 60}})));
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(transformation(origin = {24, 0}, extent = {{-76, -50}, {-56, -30}})));
  Modelica.Blocks.Math.Abs abs2 annotation (
    Placement(transformation(origin = {24, -10}, extent = {{-76, 40}, {-56, 60}})));
  SupportModels.MapBasedRelated.Pel applyEta annotation (
    Placement(transformation(origin = {20, 0}, extent = {{20, -10}, {40, 10}})));
  Modelica.Blocks.Math.Product toPmot
    annotation (Placement(transformation(origin = {24, 0}, extent = {{-72, 0}, {-52, 20}})));
  CombiTable2Factor toEff(
    u1Factor=tauFactor,
    u2Factor=speedFactor,
    yFactor=1,
    tableOnFile=mapOnFile,
    tableName=effTableName,
    fileName=mapFileName, table = effTable)
    annotation (Placement(transformation(origin = {24, 0}, extent = {{-20, -26}, {0, -6}})));
  Modelica.Blocks.Interfaces.RealOutput elePow(unit="W")  annotation (
    Placement(transformation(origin = {8, 0}, extent = {{60, -10}, {80, 10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
equation
  connect(tau, abs2.u) annotation (
    Line(points = {{-92, 40}, {-54, 40}},          color = {0, 0, 127}));
  connect(w, abs1.u) annotation (
    Line(points = {{-92, -40}, {-54, -40}}, color = {0, 0, 127}));
  connect(applyEta.Pel, elePow) annotation (
    Line(points = {{61, 0}, {78, 0}},                                 color = {0, 0, 127}));
  connect(toPmot.u1, tau) annotation (Line(
      points = {{-50, 16}, {-60, 16}, {-60, 40}, {-92, 40}},
      color={0,0,127}));
  connect(toPmot.u2, w) annotation (Line(
      points = {{-50, 4}, {-60, 4}, {-60, -40}, {-92, -40}},
      color={0,0,127}));
  connect(toPmot.y, applyEta.P) annotation (Line(
      points = {{-27, 10}, {8, 10}, {8, 6}, {38, 6}},
      color={0,0,127}));
  connect(applyEta.eta, toEff.y) annotation (Line(points={{38,-6},{32,-6},{32,-16},
          {25,-16}}, color={0,0,127}));
  connect(abs2.y, toEff.u1) annotation (Line(points={{-31,40},{-8,40},{-8,-10.2},
          {2,-10.2}}, color={0,0,127}));
  connect(toEff.u2, abs1.y) annotation (Line(points={{2,-22},{-4,-22},{-4,-40},
          {-31,-40}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-80,-60},{80,
            60}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 72}, {100, -72}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-74, -54}, {-74, 58}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-82, -48}, {78, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-74, 38}, {-24, 38}, {-4, 12}, {28, -8}, {60, -22}, {62, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{-20, 14}, {-40, 24}, {-56, -4}, {-38, -36}, {12, -38}, {26, -28}, {22, -20}, {8, -6}, {-8, 4}, {-20, 14}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-28, 4}, {-38, 2}, {-32, -20}, {0, -32}, {10, -28}, {12, -20}, {-28, 4}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-102, 118}, {100, 78}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Text(extent={{-2,54},
              {86,20}},                                                                                                                                                                                                        lineColor={0,0,0},
          textString="T")}),
    Documentation(info="<html>
<p>This block computes the machine and inverter losses from the mechanical input quantities and determines the power to be drawn from the electric circuit. The &quot;drawn&quot; power can be also a negative numer, meaning that the machine is actually delivering electric power.</p>
<p>The given efficiency map is intended as being built with torques being <i>normalised</i>, i.e. ratios of actual torques to tauMax and speeds being ratios of w to wMax.  In case the user uses, in the given efficiency map, torques in Nm and speeds in rad/s, the block can be used selecting tauTmax=1, wMax=1.</p>
<p>The choice of having normalised efficiency computation allows simulations of machines different in sizes and similar in characteristics to be repeated without having to rebuild the efficiency maps. </p>
<p>Torques are written in the first matrix column, speeds on the first row.</p>
<p>The efficiency table can be taken from a file, or specified online as a paramater.</p>
</html>"));
end EfficiencyCT;
