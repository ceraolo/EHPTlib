within EHPTlib.ElectricDrives.TestingModels;
model StartASMA "Compares U/f=cost and mains start-ups"
  //
  import Modelica.Constants.pi;
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox(terminalConnection = "Y") annotation (
    Placement(visible = true, transformation(extent = {{4, 38}, {24, 58}}, rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.InductionMachines.IM_SquirrelCage
    aimc annotation (Placement(visible=true, transformation(extent={{4,8},
            {24,28}}, rotation=0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(extent = {{-112, -6}, {-92, 14}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Basic.Star star annotation (Placement(
        visible=true, transformation(
        origin={-102,38},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (
    Placement(visible = true, transformation(origin = {78, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant tauLoad(k = -150) annotation (
    Placement(visible = true, transformation(origin = {111, -11}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  SupportModels.Miscellaneous.AronSensor pUp annotation (
    Placement(visible = true, transformation(extent = {{-52, 44}, {-34, 62}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Sources.SignalVoltage signalV annotation (
     Placement(visible=true, transformation(
        origin={-72,53},
        extent={{-10,-9},{10,9}},
        rotation=180)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (
    Placement(visible = true, transformation(origin = {61, -1}, extent = {{-7, -7}, {7, 7}}, rotation = 270)));
  Modelica.Mechanics.Rotational.Sources.Torque torque1 annotation (
    Placement(visible = true, transformation(origin = {76, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox1(terminalConnection = "Y") annotation (
    Placement(visible = true, transformation(extent = {{10, -36}, {30, -16}}, rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.InductionMachines.IM_SquirrelCage
    aimc0 annotation (Placement(visible=true, transformation(extent={{10,
            -66},{30,-46}}, rotation=0)));
  Modelica.Electrical.Polyphase.Sensors.CurrentSensor Idown annotation (
      Placement(visible=true, transformation(
        origin={-6,-30},
        extent={{-8,-8},{8,8}},
        rotation=0)));
  Modelica.Electrical.Analog.Basic.Ground ground2 annotation (
    Placement(visible = true, transformation(extent = {{-118, -78}, {-98, -58}}, rotation = 0)));
  Modelica.Electrical.Polyphase.Basic.Star star2 annotation (Placement(
        visible=true, transformation(
        origin={-98,-34},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Electrical.Polyphase.Sources.SineVoltage sineVoltage(f=50*ones(
        3), V=100*sqrt(2)*ones(3)) annotation (Placement(visible=true,
        transformation(extent={{-78,-44},{-58,-24}}, rotation=0)));
  Modelica.Electrical.Polyphase.Sensors.CurrentSensor iUp annotation (
      Placement(visible=true, transformation(
        origin={-14,54},
        extent={{-8,-8},{8,8}},
        rotation=0)));
  SupportModels.Miscellaneous.AronSensor pDown annotation (
    Placement(visible = true, transformation(extent = {{-48, -44}, {-30, -26}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5) annotation (
    Placement(visible = true, transformation(extent = {{34, 8}, {54, 28}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia0(J = 0.5) annotation (
    Placement(visible = true, transformation(extent = {{38, -66}, {58, -46}}, rotation = 0)));
  ASMArelated.ControlLogic logic(Lstray = 0.2036 / 314.16, Rr = aimc.Rr, Rs = aimc.Rs, uBase = 100 * sqrt(3), pp = 2, wmMax = 314.16 / 2) annotation (
    Placement(visible = true, transformation(extent = {{-32, 0}, {-52, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 220) annotation (
    Placement(visible = true, transformation(origin = {-14, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ASMArelated.GenSines actuator annotation (
    Placement(visible = true, transformation(extent = {{-62, 0}, {-84, 20}}, rotation = 0)));
equation
  connect(tauLoad.y, torque1.tau) annotation (
    Line(points = {{101.1, -11}, {98, -11}, {98, -24}, {94, -24}, {94, -56}, {88, -56}}, color = {0, 0, 127}));
  connect(tauLoad.y, torque.tau) annotation (
    Line(points = {{101.1, -11}, {98, -11}, {98, 18}, {90, 18}}, color = {0, 0, 127}));
  connect(torque1.flange, inertia0.flange_b) annotation (
    Line(points = {{66, -56}, {66, -56}, {58, -56}}));
  connect(aimc0.flange, inertia0.flange_a) annotation (
    Line(points = {{30, -56}, {38, -56}}));
  connect(Idown.plug_n, terminalBox1.plugSupply) annotation (
    Line(points = {{2, -30}, {20, -30}}, color = {0, 0, 255}));
  connect(terminalBox1.plug_sn, aimc0.plug_sn) annotation (
    Line(points = {{14, -32}, {14, -46}}, color = {0, 0, 255}));
  connect(terminalBox1.plug_sp, aimc0.plug_sp) annotation (
    Line(points = {{26, -32}, {26, -46}}, color = {0, 0, 255}));
  connect(pDown.nc, Idown.plug_p) annotation (
    Line(points = {{-30, -35}, {-14, -35}, {-14, -30}}, color = {0, 0, 255}));
  connect(pDown.pc, sineVoltage.plug_n) annotation (
    Line(points = {{-48, -35}, {-48.09, -35}, {-48.09, -34}, {-58, -34}}, color = {0, 0, 255}));
  connect(sineVoltage.plug_p, star2.plug_p) annotation (
    Line(points = {{-78, -34}, {-88, -34}}, color = {0, 0, 255}));
  connect(ground2.p, star2.pin_n) annotation (
    Line(points = {{-108, -58}, {-108, -34}}, color = {0, 0, 255}));
  connect(inertia.flange_b, torque.flange) annotation (
    Line(points = {{54, 18}, {62, 18}, {68, 18}}));
  connect(speedSensor.flange, torque.flange) annotation (
    Line(points = {{61, 6}, {61, 12}, {60, 12}, {60, 18}, {68, 18}}));
  connect(logic.Wm, speedSensor.w) annotation (
    Line(points = {{-42.1, -1.3}, {-42.1, -14}, {61, -14}, {61, -8.7}}, color = {0, 0, 127}));
  connect(inertia.flange_a, aimc.flange) annotation (
    Line(points = {{34, 18}, {24, 18}}));
  connect(iUp.plug_n, terminalBox.plugSupply) annotation (
    Line(points = {{-6, 54}, {-6, 54}, {14, 54}, {14, 44}}, color = {0, 0, 255}));
  connect(terminalBox.plug_sp, aimc.plug_sp) annotation (
    Line(points = {{20, 42}, {20, 28}}, color = {0, 0, 255}));
  connect(terminalBox.plug_sn, aimc.plug_sn) annotation (
    Line(points = {{8, 42}, {8, 28}}, color = {0, 0, 255}));
  connect(ground.p, star.pin_n) annotation (
    Line(points = {{-102, 14}, {-102, 28}}, color = {0, 0, 255}));
  connect(iUp.plug_p, pUp.nc) annotation (
    Line(points = {{-22, 54}, {-34, 54}, {-34, 53}}, color = {0, 0, 255}));
  connect(logic.Tstar, const1.y) annotation (
    Line(points = {{-30.1, 9.9}, {-28, 9.9}, {-28, 10}, {-25, 10}}, color = {0, 0, 127}));
  connect(actuator.Ustar, logic.Ustar) annotation (
    Line(points = {{-60.57, 4.1}, {-62.25, 4.1}, {-62.25, 4}, {-53, 4}}, color = {0, 0, 127}));
  connect(actuator.Westar, logic.Westar) annotation (
    Line(points = {{-60.57, 15.9}, {-61.35, 15.9}, {-61.35, 16}, {-53, 16}}, color = {0, 0, 127}));
  connect(actuator.U, signalV.v) annotation (
    Line(points = {{-85.1, 10}, {-88, 10}, {-88, 12}, {-88, 40}, {-72, 40}, {-72, 42.2}}, color = {0, 0, 127}));
  connect(pUp.pc, signalV.plug_p) annotation (
    Line(points = {{-52, 53}, {-62, 53}}, color = {0, 0, 255}));
  connect(signalV.plug_n, star.plug_p) annotation (
    Line(points = {{-82, 53}, {-102, 53}, {-102, 48}}, color = {0, 0, 255}));
  annotation (
    experimentSetupOutput,
    Documentation(info = "<html>
<p>This system simulates variable-frequency start-up of an asyncronous motor.</p>
<p>Two different sources for the machine are compared.</p>
<p>The motor supply is constituted by a three-phase system of quasi-sinusoidal shapes, created according to the following equations:</p>
<p>WEl=WMecc*PolePairs+DeltaWEl</p>
<p>U=U0+(Un-U0)*WEl/WNom</p>
<p>where:</p>
<ul>
<li>U0, Un U, are initial, nominal actual voltage amplitudes</li>
<li>WMecc, WEl, are machine, mechanical and supply, electrical angular speeds</li>
<li>PolePairs are the machine pole pairs</li>
<li>delta WEl is a fixed parameter during the simulation, except when the final speed is reached</li>
</ul>
<p>When the final speed is reached, the feeding frequenccy and voltage are kept constant (no flux weaking simulated)</p>
</html>"),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-120, -80}, {120, 80}}, preserveAspectRatio = false, initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.0006));
end StartASMA;
