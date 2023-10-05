within EHPTlib.ElectricDrives.TestingModels;
model AsmaTqFollowing "Compares U/f=cost and mains start-ups"
  //
  import Modelica.Constants.pi;
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox annotation (
    Placement(visible = true, transformation(extent = {{4, 14}, {24, 34}}, rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.InductionMachines.IM_SquirrelCage
    aimc annotation (Placement(visible=true, transformation(extent={{4,-16},
            {24,4}}, rotation=0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(extent = {{-98, -36}, {-78, -16}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Basic.Star star annotation (Placement(
        visible=true, transformation(
        origin={-88,8},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.Polyphase.Sensors.AronSensor pUp annotation (
      Placement(visible=true, transformation(extent={{-38,14},{-20,32}},
          rotation=0)));
  Modelica.Electrical.Polyphase.Sources.SignalVoltage signalV annotation (
     Placement(visible=true, transformation(
        origin={-58,23},
        extent={{-10,-9},{10,9}},
        rotation=180)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (
    Placement(visible = true, transformation(origin = {61, -25}, extent = {{-7, -7}, {7, 7}}, rotation = 270)));
  Modelica.Electrical.Polyphase.Sensors.CurrentSensor iUp annotation (
      Placement(visible=true, transformation(
        origin={-6,40},
        extent={{-8,-8},{8,8}},
        rotation=0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5) annotation (
    Placement(visible = true, transformation(extent = {{34, -16}, {54, 4}}, rotation = 0)));
  EHPTlib.ElectricDrives.ASMArelated.ControlLogic logic(
    Lstray=aimc.Lssigma + aimc.Lrsigma,
    Rr=aimc.Rr,
    Rs=aimc.Rs,
    pp=aimc.p,
    uBase=200*sqrt(3),
    weBase=500,
    wmMax=314.16) annotation (Placement(visible=true, transformation(extent={{-18,
            -54},{-38,-34}}, rotation=0)));
  EHPTlib.ElectricDrives.ASMArelated.GenSines genSines annotation (Placement(
        visible=true, transformation(
        origin={-59,-6},
        extent={{11,-10},{-11,10}},
        rotation=-90)));
  Modelica.Blocks.Sources.Trapezoid tqReq(amplitude = 150, falling = 2, offset = 50, period = 100, rising = 2, startTime = 2, width = 3) annotation (
    Placement(visible = true, transformation(origin = {10, -44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque tqRes(tau_nominal = -150, w_nominal = 157.08) annotation (
    Placement(visible = true, transformation(origin = {90, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(speedSensor.flange, inertia.flange_b) annotation (
    Line(points = {{61, -18}, {60, -18}, {60, -6}, {54, -6}, {54, -6}}));
  connect(inertia.flange_b, tqRes.flange) annotation (
    Line(points = {{54, -6}, {80, -6}}));
  connect(logic.Tstar, tqReq.y) annotation (
    Line(points = {{-16.1, -44.1}, {-10, -44.1}, {-10, -44}, {-1, -44}}, color = {0, 0, 127}));
  connect(genSines.Westar, logic.Westar) annotation (
    Line(points = {{-53.1, -18.43}, {-54.1, -18.43}, {-54.1, -36.43}, {-52.6, -36.43}, {-52.6, -38}, {-39, -38}}, color = {0, 0, 127}));
  connect(genSines.U, signalV.v) annotation (
    Line(points = {{-59, 6.1}, {-58, 6.1}, {-58, 12.2}}, color = {0, 0, 127}));
  connect(genSines.Ustar, logic.Ustar) annotation (
    Line(points = {{-64.9, -18.43}, {-63.9, -18.43}, {-63.9, -50}, {-39, -50}}, color = {0, 0, 127}));
  connect(terminalBox.plug_sn, aimc.plug_sn) annotation (
    Line(points = {{8, 18}, {8, 4}}, color = {0, 0, 255}));
  connect(terminalBox.plug_sp, aimc.plug_sp) annotation (
    Line(points = {{20, 18}, {20, 4}}, color = {0, 0, 255}));
  connect(iUp.plug_n, terminalBox.plugSupply) annotation (
    Line(points = {{2, 40}, {14, 40}, {14, 20}}, color = {0, 0, 255}));
  connect(inertia.flange_a, aimc.flange) annotation (
    Line(points = {{34, -6}, {24, -6}}));
  connect(ground.p, star.pin_n) annotation (
    Line(points = {{-88, -16}, {-88, -2}}, color = {0, 0, 255}));
  connect(signalV.plug_n, star.plug_p) annotation (
    Line(points = {{-68, 23}, {-88, 23}, {-88, 18}}, color = {0, 0, 255}));
  connect(logic.Wm, speedSensor.w) annotation (
    Line(points = {{-28.1, -55.3}, {-28.1, -62.3}, {61, -62.3}, {61, -32.7}}, color = {0, 0, 127}));
  connect(pUp.plug_p, signalV.plug_p) annotation (
    Line(points = {{-38, 23}, {-48, 23}, {-48, 23}, {-48, 23}}, color = {0, 0, 255}));
  connect(pUp.plug_n, iUp.plug_p) annotation (
    Line(points = {{-20, 23}, {-18, 23}, {-18, 40}, {-14, 40}, {-14, 40}}, color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html><head></head><body><p><font size=\"5\">This system simulates variable-frequency start-up of an asyncronous motor.</font></p>
      <p><font size=\"5\">Two different sources for the machine are compared.</font></p>
      <p><font size=\"5\">The motor supply is constituted by a three-phase system of quasi-sinusoidal shapes, created according to the following equations:</font></p>
      <p><font size=\"5\">WEl=WMecc*PolePairs+DeltaWEl</font></p>
      <p><font size=\"5\">U=U0+(Un-U0)*WEl/WNom</font></p>
      <p><font size=\"5\">where:</font></p>
      <p></p><ul>
      <li><font size=\"5\">U0, Un U, are initial, nominal actual voltage amplitudes</font></li>
      <li><font size=\"5\">WMecc, WEl, are machine, mechanical and supply, electrical angular speeds</font></li>
      <li><font size=\"5\">PolePairs are the machine pole pairs</font></li>
      <li><font size=\"5\">delta WEl is a fixed parameter during the simulation, except when the final speed is reached</font></li>
      </ul><p></p>
      <p><font size=\"5\">When the final speed is reached, the feeding frequency and voltage are kept constant (no flux weaking simulated)</font></p>
      </body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -80}, {100, 60}})),
    Diagram(coordinateSystem(extent = {{-100, -80}, {100, 60}}, preserveAspectRatio = false), graphics={  Rectangle(origin = {-57, 26}, lineColor = {255, 0, 0}, pattern = LinePattern.Dash, extent = {{-15, 10}, {15, -48}}), Text(origin = {-30, -1}, extent = {{-8, 3}, {8, -3}}, textString = "inverter")}),
    experiment(StartTime = 0, StopTime = 12, Tolerance = 0.0001, Interval = 0.0024),
    __OpenModelica_commandLineOptions = "");
end AsmaTqFollowing;
