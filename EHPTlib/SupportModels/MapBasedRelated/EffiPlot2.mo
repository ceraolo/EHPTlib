within EHPTlib.SupportModels.MapBasedRelated;
block EffiPlot2 "Utility to plot efficiencies from an effTable"
  import wbEHPTlib =
         EHPTlib;
  parameter Modelica.Units.SI.Torque tauMax(start=400)
    "Maximum machine torque(Nm)";
  parameter Modelica.Units.SI.Power powMax(start=22000)
    "Maximum drive power";
  parameter Modelica.Units.SI.AngularVelocity wMax(start=650)
    "Maximum machine speed(rad/s)";

  function eff
    input Real A, bT, bS, bP;
    input Real tq "input torque";
    input Real sp "input speed";
    output Real eff;
  protected
    Real pLoss;
  algorithm
    pLoss := A + bT * tq ^ 2 + bS * sp ^ 2 + bP * (tq * sp) ^ 2;
    eff := tq * sp / (tq * sp + pLoss);
  end eff;

  function lossFun
    input Real A, bT, bS, bP;
    input Real tq "input torque";
    input Real sp "input speed";
    output Real pLoss;
  algorithm
    pLoss := A + bT * tq ^ 2 + bS * sp ^ 2 + bP * (tq * sp) ^ 2;
  end lossFun;

  Real tauE[size(effs, 1)];
  Real tauL[size(loss, 1)];
  Real loss[:] = {0.02, 0.04, 0.06, 0.08};
  Real effs[:] = {0.75, 0.8, 0.85, 0.9};
equation
  for i in 1:size(effs, 1) loop
    effs[i] = eff(0.0005, 0.02, 0.01, 0.025, tauE[i], time);
  end for;
  for i in 1:size(loss, 1) loop
    loss[i] = lossFun(0.0005, 0.02, 0.01, 0.025, tauL[i], time);
  end for;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 72}, {100, -72}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-74, -54}, {-74, 58}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-82, -48}, {78, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Line(points = {{-74, 38}, {-24, 38}, {-4, 12}, {28, -8}, {60, -22}, {62, -48}}, color = {0, 0, 0}, smooth = Smooth.None), Polygon(points = {{-20, 14}, {-40, 24}, {-56, -4}, {-38, -36}, {12, -38}, {26, -28}, {22, -20}, {8, -6}, {-8, 4}, {-20, 14}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-28, 4}, {-38, 2}, {-32, -20}, {0, -32}, {10, -28}, {12, -20}, {-28, 4}}, lineColor = {0, 0, 0}, smooth = Smooth.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-102, 118}, {100, 78}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Text(extent = {{26, 46}, {76, 4}}, lineColor = {0, 0, 0}, textString = "M")}),
    Documentation(info = "<html>
<p>Questo modello di ausilio cerca di riprodurre i contour descritti nel file Efficiency.docx.</p>
<p>Nella versione presente ha due difetti fondamentali:</p>
<p>1) non riesce a descrivere curve polidrome a differenza di contour. Questo &egrave; critico in quanto le curve di efficienza sono proprio di questo tipo.</p>
<p>2) non riesce a gestire i casi in cui per un certo vaore della velocit&agrave; non si trova la coppia che da una data perdita. Se ad es. le perdite si cercano a partire da 0.02 dappiako da ecciciency.docx che ha curva delle perdite ha tangente verticale per velocit&agrave; pari a 1.4, ed infatti il modello proposto deve rimanere con 0.02 al di sotto di 1.4, altrimenti non converge.</p>
</html>"),
    experiment(StartTime = 0.1, StopTime = 1.35));
end EffiPlot2;
