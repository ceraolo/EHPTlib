within EHPTlib.MapBased;
package TestingModels
  extends Modelica.Icons.ExamplesPackage;

  model TestIceT
    IceT iceT(wIceStart = 90) annotation (
      Placement(transformation(extent={{-16,-2},{4,18}})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true)) annotation (
      Placement(transformation(extent={{14,0},{34,20}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation (
      Placement(transformation(extent={{68,0},{48,20}})));
    Modelica.Blocks.Sources.Trapezoid trapezoid(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 60, amplitude = 30) annotation (
      Placement(transformation(extent={{-46,-38},{-26,-18}})));
  equation
    connect(iceT.flange_a, inertia.flange_a) annotation (
      Line(points={{4,10},{14,10}},      color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, loadTorque.flange) annotation (
      Line(points={{34,10},{48,10}},      color = {0, 0, 0}, smooth = Smooth.None));
    connect(iceT.tauRef, trapezoid.y) annotation (
      Line(points={{-12,-2},{-12,-28},{-25,-28}},        color = {0, 0, 127}, smooth = Smooth.None));
  //    experiment(StopTime = 50),
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -60}, {80, 40}}), graphics={Text(
            extent={{6,-18},{64,-44}},
            textColor={238,46,47},
            textString="Model not working, see info")}),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(extent = {{-60, -60}, {80, 40}})),
      Documentation(info="<html>
<p><br><b>Model IceT works only when parameter tablesOnFile=true.</b></p>
<h4>Implementation related to TablesOnFile=false has still to be finalised. </h4>
<h4>Therefore TestIceT is currently not working</h4>
<p>Because of this, the experiment annotation has been commented out.</p>
<p><br>*******************************************************************************************</p>
<p>This is a simple test of model IceT.</p>
<p>It shows that the generated torque follows the torque request as long as the maximum allowed is not overcome; otherwise this maximum is generated.</p>
<p>It shows also the fuel consumption output.</p>
<p>The user could compare the torque request tauRef with the torque generated and at the ICE flange (with this transient the inertia torques are very small and can be neglected). The user could also have a look at the rotational speeds and fuel consumption. </p>
</html>"));
  end TestIceT;

  model TestOneFlange
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation (
      Placement(transformation(extent = {{38, 0}, {58, 20}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -50, w_nominal = 400) annotation (
      Placement(transformation(extent = {{92, 0}, {72, 20}})));
    Modelica.Blocks.Sources.Trapezoid tauRef(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 50, offset = 20) annotation (
      Placement(transformation(extent = {{-60, -38}, {-40, -18}})));
    OneFlange oneFlange(powMax = 10000, tauMax = 50, J = 0.5, wMax = 300) annotation (
      Placement(transformation(extent = {{-22, 0}, {-2, 20}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 100) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-64, 10})));
    Modelica.Electrical.Analog.Basic.Ground ground annotation (
      Placement(transformation(extent = {{-90, -20}, {-70, 0}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation (
      Placement(transformation(extent = {{12, 0}, {32, 20}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation (
      Placement(transformation(extent = {{-48, 20}, {-28, 40}})));
  equation
    connect(inertia.flange_b, loadTorque.flange) annotation (
      Line(points = {{58, 10}, {72, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tauRef.y, oneFlange.tauRef) annotation (
      Line(points = {{-39, -28}, {-32, -28}, {-32, 8}, {-23.4, 8}, {-23.4, 8.88889}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(ground.p, gen.n) annotation (
      Line(points = {{-80, 0}, {-64, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(oneFlange.flange_a, powMech.flange_a) annotation (
      Line(points = {{-2, 8.88889}, {6, 8.88889}, {6, 10}, {12, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_a, powMech.flange_b) annotation (
      Line(points = {{38, 10}, {32, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.nc, oneFlange.pin_p) annotation (
      Line(points={{-28,30},{-22,30},{-22,13.3333}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.pc, gen.p) annotation (
      Line(points = {{-48, 30}, {-64, 30}, {-64, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.pv, powElec.nc) annotation (
      Line(points = {{-38, 40}, {-28, 40}, {-28, 30}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(gen.n, oneFlange.pin_n) annotation (
      Line(points={{-64,0},{-38,0},{-38,4.44444},{-22,4.44444}},  color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.nv, oneFlange.pin_n) annotation (
      Line(points={{-38,20},{-38,4.44444},{-22,4.44444}},
                                              color = {0, 0, 255}, smooth = Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 60}}), graphics),
      experiment(StopTime = 50),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
      Documentation(info = "<html>
<p>This is a simple test of model OneFlange.</p>
<p>It shows that the generated torque follows the normalised torque request as long as it does not overcome unity. Actual torque will be this request times the maximum value that, in turn, is the minimum between tauMax and powerMax/w (while w is the rotational speed)</p>
<p>It shows also the effects of efficiency on the DC power.</p>
<p><u>First suggested plots</u>: on the same axis oneFlange.torque.tau, and tauRef vertically aligned with the previous oneFlange.limTau.state. In these plots it can be seen that:</p>
<ul>
<li>during the first 10 seconds the generated torque oneFlange.torque.tau, is 20Nm, as requested from the input. The maximum torque that can be generated is not limited by the power limit</li>
<li>between t=10 and 12 s the generated torque continues to follow the input signal; </li>
<li>between t=12 and 37.7 s, since the drive power has been reached (10 kW), the generated torque is automatically reduced to avoid this limit to be overcome </li>
<li>above t=37.7 the torque request is reduced and the drive is again able to deliver this torque.</li>
<li>All the above behaviour is confirmed by the value of boolean variable tauLimited.y.</li>
</ul>
<p><br><u>Second suggested plot</u>: Once the first plot is anaysed, the user might want to have an idea of the mechanical and electrical powers: these are seen putting in the same plot powMech.power and powElec.power.</p>
</html>"));
  end TestOneFlange;

  model TestIceConn
    Modelica.Mechanics.Rotational.Components.Inertia inertia(phi(start = 0, fixed = true), J = 10) annotation (
      Placement(transformation(extent = {{-14, 0}, {6, 20}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation (
      Placement(transformation(extent = {{64, 0}, {44, 20}})));
    IceConnP ice(wIceStart = 90, mapsFileName = "PSDmaps.txt") annotation (
      Placement(transformation(extent = {{-42, 0}, {-22, 20}})));
    SupportModels.ConnectorRelated.ToConnIcePowRef toConnIceTauRef annotation (
      Placement(transformation(extent = {{-6, -6}, {6, 6}}, rotation = 90, origin = {-32, -18})));
    Modelica.Blocks.Sources.Trapezoid powReq(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 60, amplitude = 10e3) annotation (
      Placement(transformation(extent = {{-74, -30}, {-54, -10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outPow annotation (
      Placement(transformation(extent = {{18, 0}, {38, 20}})));
  equation
    connect(inertia.flange_a, ice.flange_a) annotation (
      Line(points = {{-14, 10}, {-22, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(toConnIceTauRef.conn, ice.conn) annotation (
      Line(points = {{-32, -12}, {-32, 0.2}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None));
    connect(toConnIceTauRef.u, powReq.y) annotation (
      Line(points = {{-32, -25.4}, {-32, -32}, {-44, -32}, {-44, -20}, {-53, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(inertia.flange_b, outPow.flange_a) annotation (
      Line(points = {{6, 10}, {18, 10}}, color = {0, 0, 0}));
    connect(loadTorque.flange, outPow.flange_b) annotation (
      Line(points = {{44, 10}, {38, 10}}, color = {0, 0, 0}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -60}, {80, 60}})),
      experiment(StopTime = 50),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(extent = {{-80, -60}, {80, 60}})),
      Documentation(info = "<html>
<p>This is a simple test of model IceConn, loaded with a huge inertia and a quadratic dependent load torque.</p>
<p>It shows that the generated power (variable icePowDel inside connectors and bus) follows the power request. The load power outPow.Power differs from the generated power due to the large inertia in-between. If closer matching between icePowDel and powReq.y is wanted the ice inner control gain contrGain can be raised.</p>
<p>It shows also the fuel consumption output. The user could also have a look at the rotational speed. </p>
</html>"));
  end TestIceConn;

  model TestOneFlangeConn
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation (
      Placement(transformation(extent = {{38, 0}, {58, 20}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -50, w_nominal = 400) annotation (
      Placement(transformation(extent = {{92, 0}, {72, 20}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 100) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-64, 10})));
    Modelica.Electrical.Analog.Basic.Ground ground annotation (
      Placement(transformation(extent = {{-90, -20}, {-70, 0}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation (
      Placement(transformation(extent = {{12, 0}, {32, 20}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation (
      Placement(transformation(extent = {{-52, 14}, {-32, 34}})));
    OneFlangeConn oneFlangeConn(powMax = 10000, tauMax = 50, J = 0.5, wMax = 300, mapsFileName = "EVmaps.txt", effTableName = "effTable") annotation (
      Placement(transformation(extent = {{-16, 0}, {4, 20}})));
    SupportModels.ConnectorRelated.ToConnGenTauRef toConnGenTauNorm annotation (
      Placement(transformation(extent = {{-16, -34}, {-4, -22}})));
    Modelica.Blocks.Sources.Trapezoid tauRef(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 50, offset = 20) annotation (
      Placement(transformation(extent = {{-48, -38}, {-28, -18}})));
  equation
    connect(inertia.flange_b, loadTorque.flange) annotation (
      Line(points = {{58, 10}, {72, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(ground.p, gen.n) annotation (
      Line(points = {{-80, 0}, {-64, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(inertia.flange_a, powMech.flange_b) annotation (
      Line(points = {{38, 10}, {32, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.pc, gen.p) annotation (
      Line(points = {{-52, 24}, {-64, 24}, {-64, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.pv, powElec.nc) annotation (
      Line(points = {{-42, 34}, {-36, 34}, {-36, 34}, {-32, 34}, {-32, 24}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powMech.flange_a, oneFlangeConn.flange_a) annotation (
      Line(points = {{12, 10}, {4, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(oneFlangeConn.pin_p, powElec.nc) annotation (
      Line(points={{-16,14},{-24,14},{-24,24},{-32,24}},         color = {0, 0, 255}, smooth = Smooth.None));
    connect(oneFlangeConn.pin_n, gen.n) annotation (
      Line(points={{-16,6},{-24,6},{-24,0},{-64,0}},              color = {0, 0, 255}, smooth = Smooth.None));
    connect(toConnGenTauNorm.conn, oneFlangeConn.conn) annotation (
      Line(points = {{-4.2, -28}, {4, -28}, {4, 2.2}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None));
    connect(powElec.nv, gen.n) annotation (
      Line(points = {{-42, 14}, {-42, 0}, {-64, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(toConnGenTauNorm.u, tauRef.y) annotation (
      Line(points = {{-17, -28}, {-27, -28}}, color = {0, 0, 127}, smooth = Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 60}}), graphics),
      experiment(StopTime = 50),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
      Documentation(info = "<html>
<p>This is a simple test of model OneFlange with bus connector.</p>
<p>For the description see the description of TestOneFlange (substitute the word &QUOT;oneFlange&QUOT; with &QUOT;oneFlangeConn&QUOT;).</p>
</html>"));
  end TestOneFlangeConn;

  model TestTwoFlange "Test of TwoFlange drive train model"
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation (
      Placement(transformation(extent = {{38, -10}, {58, 10}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 400, tau_nominal = -50.0) annotation (
      Placement(transformation(extent = {{92, -10}, {72, 10}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 100) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-60, 28})));
    Modelica.Electrical.Analog.Basic.Ground ground annotation (
      Placement(transformation(extent = {{-100, -2}, {-80, 18}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech2 annotation (
      Placement(transformation(extent = {{12, -10}, {32, 10}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation (
      Placement(transformation(extent = {{-48, 32}, {-28, 52}})));
    TwoFlange twoFlanges(J = 0.5, wMax = 300, tauMax = 60, powMax = 22000, mapsFileName = "EVmaps.txt", effTableName = "effTable") annotation (
      Placement(transformation(extent = {{-18, -10}, {2, 10}})));
    Modelica.Mechanics.Rotational.Sources.ConstantTorque tau1(tau_constant = -5.0) annotation (
      Placement(transformation(extent = {{-76, -10}, {-56, 10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech1 annotation (
      Placement(transformation(extent = {{-28, -10}, {-48, 10}})));
    Modelica.Blocks.Sources.Trapezoid tauRef(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 50, offset = 20) annotation (
      Placement(transformation(extent = {{-40, -48}, {-20, -28}})));
  equation
    connect(inertia.flange_b, loadTorque.flange) annotation (
      Line(points = {{58, 0}, {72, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(ground.p, gen.n) annotation (
      Line(points = {{-90, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(inertia.flange_a, powMech2.flange_b) annotation (
      Line(points = {{38, 0}, {32, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.pc, gen.p) annotation (
      Line(points = {{-48, 42}, {-60, 42}, {-60, 38}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.pv, powElec.nc) annotation (
      Line(points = {{-38, 52}, {-28, 52}, {-28, 42}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powMech2.flange_a, twoFlanges.flange_b) annotation (
      Line(points = {{12, 0}, {8, 0}, {8, -0.2}, {2, -0.2}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.nc, twoFlanges.pin_n) annotation (
      Line(points = {{-28, 42}, {-4, 42}, {-4, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(twoFlanges.pin_p, gen.n) annotation (
      Line(points = {{-12, 9.8}, {-12, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.nv, gen.n) annotation (
      Line(points = {{-38, 32}, {-38, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(twoFlanges.flange_a, powMech1.flange_a) annotation (
      Line(points = {{-18, 0}, {-28, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tau1.flange, powMech1.flange_b) annotation (
      Line(points = {{-56, 0}, {-48, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tauRef.y, twoFlanges.tauRef) annotation (
      Line(points = {{-19, -38}, {-8, -38}, {-8, -9.2}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 60}})),
      experiment(StopTime = 50),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
      Documentation(info = "<html>
<p>This is a simple test of model TwoFlange. </p>
<p>It shows that the generated torque follows the normalised torque request as long as it does not overcome torque and power limits. The generated torque will act on the machine inertia in conjunction with the torques applied from the exterior to the two flanges. </p>
<p>It shows also the effects of efficiency on the DC power. </p>
<p>First suggested plots: a plot with tauRef.y and twoFlanges.inertia.flange_a.tau; with the same axes another plot with twoFlanges.limTau.powLimActive and twoFlanges.limTau.powLimActive. In these plots it can be seen that: </p>
<p>&middot;<span style=\"font-size: 7pt;\">&nbsp; </span>during the first 18 seconds the generated torque equals the torque request tauRef.y </p>
<p>&middot;<span style=\"font-size: 7pt;\">&nbsp; </span>between 18 and 21 s the maximum torque limit is reached, but not the maximum power limit </p>
<p>&middot;<span style=\"font-size: 7pt;\">&nbsp; </span>between 21 and 33 s the maximum power occurs </p>
<p>&middot;<span style=\"font-size: 7pt;\">&nbsp; </span>after 33s, the requested torque is delivered. </p>
<p>Second suggested plot: once the first plots are analysed, the user might want to have an idea of the mechanical and electrical powers: these are seen putting in the same plot (powMech1.power+powMech2.power) and powElec.power. </p>
</html>"));
  end TestTwoFlange;
end TestingModels;
