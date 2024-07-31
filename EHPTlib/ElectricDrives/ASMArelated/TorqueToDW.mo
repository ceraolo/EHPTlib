within EHPTlib.ElectricDrives.ASMArelated;
model TorqueToDW "Torque to Delta Omega"
  parameter Modelica.Units.SI.Resistance Rr
    "Rotor resistance in stato units";
  parameter Integer pp "Pole pairs";
  parameter Real Kw "Constant Komega of FEPE Book";
  parameter Modelica.Units.SI.AngularVelocity wmBase=314.16
    "Base electric frequency";
  parameter Modelica.Units.SI.Inductance Lstray
    "Combined stray inductance";
  //The following is 12.11 of FEPE book, when U1=Kw*W (LS stands for low speed)
  Modelica.Units.SI.Torque Tmax;
public
  Modelica.Blocks.Interfaces.RealInput u annotation (
    Placement(transformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Blocks.Interfaces.RealInput Wm annotation (
    Placement(transformation(extent = {{-140, -80}, {-100, -40}})));
  Modelica.Blocks.Interfaces.BooleanOutput tauIsMax annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {0, -110})));
equation
  if Wm < wmBase then
    Tmax = 3 * Kw ^ 2 / (2 * pp * Lstray);
  else
    //The following is 12.11 of FEPE book
    Tmax = 3 * (Kw * wmBase) ^ 2 / (2 * pp * Wm ^ 2 * Lstray);
  end if;
  //Se la coppia richiesta supera la massima mi attesto al deltaW
  //che corrisponde al picco di coppia
  if u > Tmax then
    Tmax = 3 * Rr * y * Kw ^ 2 / ((pp * y * Lstray) ^ 2 + Rr ^ 2);
    //    y = Rr / (pp*Lstray);
    tauIsMax = true;
  elseif u < (-Tmax) then
    -Tmax = 3 * Rr * y * Kw ^ 2 / ((pp * y * Lstray) ^ 2 + Rr ^ 2);
    //    y = -Rr / (pp * Lstray);
    tauIsMax = true;
  else
    /* La seguente riga è eq. 12.14 di FEPE Book. Naturalmente essa 
        determina una richiesta di coppia corretta a pieno flusso, zona nella quale 
        vale la 12.14, mentre è approssimata in deflussaggio. Peraltro essendo 
        normalmente il controllo in velocità in retroazione, in questo modello 
        semplificato si accetta questo tipo di delta_omega, che determina una 
        potenza decrescente invece che costante come potrebbe essere.       
      */
    u = 3 * Rr * y * Kw ^ 2 / ((pp * y * Lstray) ^ 2 + Rr ^ 2);
    /*  Si potrebbe completare il controllo facendo in modo che al di sopra della 
        velocità base si applichi la formula 12.10 di FEPE in cui U1=Kw*wmBase.
        Al posto di W0 si può mettere Wm+y.
        Le formule si complicano e quindi per ragioni didattiche non lo facciamo.
        
        Si riporta comunque qui sotto un'implementazione provvisoria con coppia 
        valida in tutte le regioni, da ultimare e verificare:
        */
    //u=3*(Kw*wmBase)^2*Rr*y/(y^2*pp^2*(Wm+y)^2*Lstray^2+Rr^2*(Wm+y));
    tauIsMax = false;
  end if;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-100, 144}, {98, 106}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Line(points = {{-67, -26}, {-51, -26}, {-51, -22}, {-49, -15}, {-40, -8}, {18, 25}, {26, 32}, {29, 37}, {29, 42}, {49, 42}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-66, 8}, {78, 8}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-12, -44}, {-12, 82}}, color = {0, 0, 127}, smooth = Smooth.None), Line(points = {{-20, 72}, {-12, 84}, {-6, 72}}, color = {0, 0, 127}, smooth = Smooth.None), Text(extent = {{16, 72}, {52, 44}}, lineColor = {0, 0, 127}, textString = "DW"), Line(points = {{-7, -6}, {1, 6}, {7, -6}}, color = {0, 0, 127}, smooth = Smooth.None, origin = {75, 8}, rotation = 270), Text(extent = {{60, -6}, {96, -34}}, lineColor = {0, 0, 127}, textString = "T")}));
end TorqueToDW;
