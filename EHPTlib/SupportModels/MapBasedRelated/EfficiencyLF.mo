within EHPTlib.SupportModels.MapBasedRelated;
block EfficiencyLF
  "Determines the electric power from the mechanical considering efficiency map"
  parameter Real A = 0.006 "fixed losses";
  parameter Real bT = 0.05 "torque losses coefficient";
  parameter Real bW = 0.02 "speed losses coefficient";
  parameter Real bP = 0.05 "power losses coefficient";
  parameter Modelica.Units.SI.Torque tauMax(start=400)
    "Maximum machine torque";
  parameter Modelica.Units.SI.Power powMax(start=22000)
    "Maximum drive power";
  parameter Modelica.Units.SI.AngularVelocity wMax(start=650)
    "Maximum machine speed";
  Modelica.Blocks.Interfaces.RealInput w annotation (
    Placement(transformation(extent = {{-140, -60}, {-100, -20}}), iconTransformation(extent = {{-140, -60}, {-100, -20}})));
  Modelica.Blocks.Interfaces.RealInput tau annotation (
    Placement(transformation(extent = {{-140, 20}, {-100, 60}}), iconTransformation(extent = {{-140, 20}, {-100, 60}})));
  Modelica.Blocks.Interfaces.RealOutput elePow annotation (
    Placement(transformation(extent = {{96, -10}, {116, 10}})));
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(transformation(extent = {{-76, -50}, {-56, -30}})));
  Modelica.Blocks.Math.Abs abs2 annotation (
    Placement(transformation(extent = {{-80, 40}, {-60, 60}})));
  Modelica.Blocks.Math.Gain normalizeTau(k = 1 / tauMax) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-36, 50})));
  SupportModels.MapBasedRelated.Pel applyEta annotation (
    Placement(transformation(extent = {{60, -10}, {84, 12}})));
  Modelica.Blocks.Math.Product PMOT annotation (
    Placement(transformation(extent = {{-72, 0}, {-52, 20}})));
  Modelica.Blocks.Math.Gain normalizeSpeed(k = 1 / wMax) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-34, -40})));
  ComputeEffFromPu toEff(
    A=A,
    bT=bT,
    bW=bW,
    bP=bP)
    annotation (Placement(transformation(extent={{12,-26},{32,-6}})));
equation
  connect(tau, abs2.u) annotation (
    Line(points = {{-120, 40}, {-94, 40}, {-94, 50}, {-82, 50}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(w, abs1.u) annotation (
    Line(points = {{-120, -40}, {-78, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(abs2.y, normalizeTau.u) annotation (
    Line(points = {{-59, 50}, {-48, 50}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(applyEta.Pel, elePow) annotation (
    Line(points = {{85.2, 1}, {92.48, 1}, {92.48, 0}, {106, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(PMOT.u1, tau) annotation (
    Line(points = {{-74, 16}, {-84, 16}, {-84, 40}, {-120, 40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(PMOT.u2, w) annotation (
    Line(points = {{-74, 4}, {-84, 4}, {-84, -40}, {-120, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(PMOT.y, applyEta.P) annotation (
    Line(points = {{-51, 10}, {42, 10}, {42, 7.6}, {57.6, 7.6}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(abs1.y, normalizeSpeed.u) annotation (
    Line(points = {{-55, -40}, {-46, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(normalizeTau.y, toEff.Tu) annotation (Line(points={{-25,50},{-10,
          50},{-10,-10},{10.2,-10}}, color={0,0,127}));
  connect(toEff.Wu, normalizeSpeed.y) annotation (Line(points={{10.2,-22},
          {-6,-22},{-6,-40},{-23,-40}}, color={0,0,127}));
  connect(toEff.y, applyEta.eta) annotation (Line(points={{32.6,-16},{38,
          -16},{38,-6},{48,-6},{48,-5.6},{57.6,-5.6}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 72}, {100, -72}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-74, -54}, {-74, 58}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-82, -48}, {78, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-74, 38}, {-24, 38}, {-4, 12}, {28, -8}, {60, -22}, {62, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{-20, 14}, {-40, 24}, {-56, -4}, {-38, -36}, {12, -38}, {26, -28}, {22, -20}, {8, -6}, {-8, 4}, {-20, 14}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-28, 4}, {-38, 2}, {-32, -20}, {0, -32}, {10, -28}, {12, -20}, {-28, 4}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-102, 118}, {100, 78}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Text(extent = {{26, 46}, {76, 4}}, lineColor={0,0,0},
          textString="L")}),
    Documentation(info = "<html>
<p>This block computes the machine and inverter losses from the mechanical input quantities and determines the power to be drawn from the electric circuit. The &QUOT;drawn&QUOT; power can be also a negative numer, meaning that themachine is actually delivering electric power.</p>
<p>The given efficiency map is intended as being built with torques being ratios of actual torques to tauMax and speeds being ratios of w to wMax. In case the user uses, in the given efficiency map, torques in Nm and speeds in rad/s, the block can be used selecting tauTmax=1, wMax=1.</p>
<p>The choice of having normalised efficiency computation allows simulations of machines different in sizes and similar in characteristics to be repeated without having to rebuild the efficiency maps. </p>
<p>Torques are written in the first matrix column, speeds on the first row.</p>
</html>"));
end EfficiencyLF;
