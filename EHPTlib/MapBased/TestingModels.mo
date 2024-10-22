within EHPTlib.MapBased;

package TestingModels
  extends Modelica.Icons.ExamplesPackage;

  package TestOneFlange
    model TestOneFlange1 "Tests OneFlange with fixed torque limits and loss formula"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 7, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
        Placement(transformation(extent = {{40, -10}, {60, 10}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -150, w_nominal = 250) annotation(
        Placement(transformation(extent = {{94, -10}, {74, 10}})));
      Modelica.Blocks.Sources.Trapezoid tauRef(rising = 5, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 450, offset = 10) annotation(
        Placement(transformation(extent = {{-58, -38}, {-38, -18}})));
      OneFlange oneFlange(powMax(displayUnit = "kW") = 7e4, limitsOnFile = false, tauMax = 400, J = 0.2, wMax = 200, effMapOnFile = false, efficiencyFromTable = false, uDcNom = 400) annotation(
        Placement(transformation(extent = {{-20, -10}, {0, 10}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 400) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-62, 10})));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(transformation(extent = {{-82, -20}, {-62, 0}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation(
        Placement(transformation(extent = {{14, -10}, {34, 10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
        Placement(transformation(extent = {{-46, 20}, {-26, 40}})));
    equation
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{60, 0}, {74, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(tauRef.y, oneFlange.tauRef) annotation(
        Line(points = {{-37, -28}, {-30, -28}, {-30, 0}, {-21.4, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(ground.p, gen.n) annotation(
        Line(points = {{-72, 0}, {-62, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(oneFlange.flange_a, powMech.flange_a) annotation(
        Line(points = {{0, 0}, {14, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_a, powMech.flange_b) annotation(
        Line(points = {{40, 0}, {34, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(powElec.nc, oneFlange.pin_p) annotation(
        Line(points = {{-26, 30}, {-20, 30}, {-20, 4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pc, gen.p) annotation(
        Line(points = {{-46, 30}, {-62, 30}, {-62, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pv, powElec.nc) annotation(
        Line(points = {{-36, 40}, {-26, 40}, {-26, 30}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(gen.n, oneFlange.pin_n) annotation(
        Line(points = {{-62, 0}, {-62, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.nv, oneFlange.pin_n) annotation(
        Line(points = {{-36, 20}, {-36, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -60}, {100, 60}}), graphics = {Text(origin = {2, 24}, textColor = {238, 46, 47}, extent = {{0, -54}, {48, -72}}, textString = "- 70 kW - 400 Nm
- Fixed torque limits 
- Loss formula", horizontalAlignment = TextAlignment.Left)}),
        experiment(StopTime = 50),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
        Documentation(info = "<html><head></head><body><p class=\"MsoNormal\"><span style=\"mso-no-proof:yes\">It shows that the generated
torque follows the normalised torque request as long as it does not overcome
the allowed maximum. Actual torque will be this request times the maximum value
that, in turn, is the minimum between tauMax and powerMax/w (while w is the
rotational speed)<o:p></o:p></span></p><p class=\"MsoNormal\"><span style=\"mso-no-proof:yes\">It shows also the effects of
efficiency on the DC power.<o:p></o:p></span></p><p class=\"MsoNormal\"><u><span style=\"mso-no-proof:yes\">First suggested group of plots</span></u><span style=\"mso-no-proof:yes\">: on the same axis oneFlange.torque.tau, and tauRef
vertically aligned with the previous oneFlange.limTau.state and
oneFlange.limitingTorque. In these plots it can be seen that:<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:21.3pt;text-indent:-14.2pt;mso-list:l0 level1 lfo1\"><!--[if !supportLists]--><span style=\"font-size:10.0pt;mso-bidi-font-size:11.0pt;line-height:107%;font-family:
Symbol;mso-fareast-font-family:Symbol;mso-bidi-font-family:Symbol;mso-no-proof:
yes\"><span style=\"mso-list:Ignore\">·<span style=\"font:7.0pt &quot;Times New Roman&quot;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]--><span style=\"mso-no-proof:yes\">during the first
10 seconds the generated torque oneFlange.torque.tau, is 100Nm, as requested
from the input. The maximum torque that can be generated is not limited by the nor
the torque limit nor the power limit. Reached speed is 54 rad/s.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:21.3pt;text-indent:-14.2pt;mso-list:l0 level1 lfo1\"><!--[if !supportLists]--><span style=\"font-size:10.0pt;mso-bidi-font-size:11.0pt;line-height:107%;font-family:
Symbol;mso-fareast-font-family:Symbol;mso-bidi-font-family:Symbol;mso-no-proof:
yes\"><span style=\"mso-list:Ignore\">·<span style=\"font:7.0pt &quot;Times New Roman&quot;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]--><span style=\"mso-no-proof:yes\">between t=10 and 14.3
s the generated torque continues to follow the input signal, without hitting
limits (limitingTorque=0 and state=0)<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:21.3pt;text-indent:-14.2pt;mso-list:l0 level1 lfo1\"><!--[if !supportLists]--><span style=\"font-size:10.0pt;mso-bidi-font-size:11.0pt;line-height:107%;font-family:
Symbol;mso-fareast-font-family:Symbol;mso-bidi-font-family:Symbol;mso-no-proof:
yes\"><span style=\"mso-list:Ignore\">·<span style=\"font:7.0pt &quot;Times New Roman&quot;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]--><span style=\"mso-no-proof:yes\">at t=14.3s the maxTorque
limit is reached: limitingTorque =1, state remains 0 because we still are below
wBase<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:21.3pt;text-indent:-14.2pt;mso-list:l0 level1 lfo1\"><!--[if !supportLists]--><span style=\"font-size:10.0pt;mso-bidi-font-size:11.0pt;line-height:107%;font-family:
Symbol;mso-fareast-font-family:Symbol;mso-bidi-font-family:Symbol;mso-no-proof:
yes\"><span style=\"mso-list:Ignore\">·<span style=\"font:7.0pt &quot;Times New Roman&quot;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]--><span style=\"mso-no-proof:yes\">at t=15.2s we
reach the maximun power limit, state becomes 2. <o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:21.3pt;text-indent:-14.2pt;mso-list:l0 level1 lfo1\"><!--[if !supportLists]--><span style=\"font-size:10.0pt;mso-bidi-font-size:11.0pt;line-height:107%;font-family:
Symbol;mso-fareast-font-family:Symbol;mso-bidi-font-family:Symbol;mso-no-proof:
yes\"><span style=\"mso-list:Ignore\">·<span style=\"font:7.0pt &quot;Times New Roman&quot;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]--><span style=\"mso-no-proof:yes\">Starting from 15.2s,
the delivered power is reduced because we are in the max speed limiting zone.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:21.3pt;text-indent:-14.2pt;mso-list:l0 level1 lfo1\"><u>Second suggested group of plots:&nbsp;</u></p><p class=\"MsoNormal\" style=\"margin-left:7.1pt\"><span style=\"mso-no-proof:yes\">This
behaviour can be well undertood by means of a parametric plot, putting speed on
the abscissa, tauRef, oneFlange.torque, and loadTorque.flange.tau on the
ordinate.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left: 21.3pt; text-indent: -14.2pt;\">To analyse this complex plot well, a plot of inertia.w versus time is helpful.</p><p></p><p><u>Further suggested plots</u>: Once the first plot is anaysed, the user might want to have an idea of the mechanical and electrical powers: these are seen putting in the same plot powMech.power and powElec.power. The trend of efficiency could be also of interest (variable oneFlange.toElePow1.toEff.y)</p>
    </body></html>"));
    end TestOneFlange1;

    model TestOneFlange2 "Tests OneFlange with torque limits from file (unNormalised) and loss formula"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 7, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
        Placement(transformation(extent = {{40, -10}, {60, 10}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -150, w_nominal = 250) annotation(
        Placement(transformation(extent = {{94, -10}, {74, 10}})));
      Modelica.Blocks.Sources.Trapezoid tauRef(rising = 5, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 450, offset = 10) annotation(
        Placement(transformation(extent = {{-58, -38}, {-38, -18}})));
      OneFlange oneFlange(powMax = 7e4, limitsOnFile = true, tauMax = 400, J = 0.2, wMax = 20.943951023931955, limitsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt"), tauLimitsMapName = "minMaxTorque", uDcNom = 400, efficiencyFromTable = false, bT = 0, bW = 0.003, bP = 0, A = 0.04) annotation(
        Placement(transformation(extent = {{-20, -10}, {0, 10}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 400) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-62, 10})));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(transformation(extent = {{-82, -20}, {-62, 0}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation(
        Placement(transformation(extent = {{14, -10}, {34, 10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
        Placement(transformation(extent = {{-46, 20}, {-26, 40}})));
    equation
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{60, 0}, {74, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(tauRef.y, oneFlange.tauRef) annotation(
        Line(points = {{-37, -28}, {-30, -28}, {-30, 0}, {-21.4, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(ground.p, gen.n) annotation(
        Line(points = {{-72, 0}, {-62, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(oneFlange.flange_a, powMech.flange_a) annotation(
        Line(points = {{0, 0}, {14, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_a, powMech.flange_b) annotation(
        Line(points = {{40, 0}, {34, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(powElec.nc, oneFlange.pin_p) annotation(
        Line(points = {{-26, 30}, {-20, 30}, {-20, 4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pc, gen.p) annotation(
        Line(points = {{-46, 30}, {-62, 30}, {-62, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pv, powElec.nc) annotation(
        Line(points = {{-36, 40}, {-26, 40}, {-26, 30}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(gen.n, oneFlange.pin_n) annotation(
        Line(points = {{-62, 0}, {-62, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.nv, oneFlange.pin_n) annotation(
        Line(points = {{-36, 20}, {-36, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -60}, {100, 60}}), graphics = {Text(origin = {2, -4}, textColor = {238, 46, 47}, extent = {{0, -24}, {78, -36}}, textString = "- around 70 kW, Max 700 Nm
    - Torque limits from file (rpm, Nm)
    - Loss formula", horizontalAlignment = TextAlignment.Left)}),
        experiment(StopTime = 50),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
        Documentation(info = "<html><head></head><body><p>Second simple test of model OneFlange.</p>
    <p>Siimilar to TestOneFlange1, but torque limits taken from a file (un-normalised).&nbsp;</p><p>Since the limits from file allow larger speeds to be reached (250 rpms instead of 210), loss formula parameters are changed to have comparable losses during the considered transient.</p><p>Suggesed plots are as per&nbsp;TestOneFlange1. Only, we note that here state is rather meaningless, since it is contantly equal to -1 as it should when limits are taken from file.</p><p>It is also useful to see oneFlange.limtau.yH versus inertia.w and see oneFlange.powSensor.power.yH versus inertia.w.</p><p><br></p>
    </body></html>"));
    end TestOneFlange2;

    model TestOneFlange3 "Tests OneFlange with torque limits from file (unNormalised) and loss formula"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 7, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
        Placement(transformation(extent = {{40, -10}, {60, 10}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -150, w_nominal = 250) annotation(
        Placement(transformation(extent = {{94, -10}, {74, 10}})));
      Modelica.Blocks.Sources.Trapezoid tauRef(rising = 5, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 450, offset = 10) annotation(
        Placement(transformation(extent = {{-58, -38}, {-38, -18}})));
      OneFlange oneFlange(powMax = 7e4, limitsOnFile = true, tauMax = 400, J = 0.2, wMax = 20.943951023931955, limitsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt"), tauLimitsMapName = "minMaxTorque", uDcNom = 400, efficiencyFromTable = false, bT = 0, bW = 0.003, bP = 0, A = 0.04) annotation(
        Placement(transformation(extent = {{-20, -10}, {0, 10}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 400) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-62, 10})));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(transformation(extent = {{-82, -20}, {-62, 0}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation(
        Placement(transformation(extent = {{14, -10}, {34, 10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
        Placement(transformation(extent = {{-46, 20}, {-26, 40}})));
    equation
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{60, 0}, {74, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(tauRef.y, oneFlange.tauRef) annotation(
        Line(points = {{-37, -28}, {-30, -28}, {-30, 0}, {-21.4, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(ground.p, gen.n) annotation(
        Line(points = {{-72, 0}, {-62, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(oneFlange.flange_a, powMech.flange_a) annotation(
        Line(points = {{0, 0}, {14, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_a, powMech.flange_b) annotation(
        Line(points = {{40, 0}, {34, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(powElec.nc, oneFlange.pin_p) annotation(
        Line(points = {{-26, 30}, {-20, 30}, {-20, 4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pc, gen.p) annotation(
        Line(points = {{-46, 30}, {-62, 30}, {-62, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pv, powElec.nc) annotation(
        Line(points = {{-36, 40}, {-26, 40}, {-26, 30}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(gen.n, oneFlange.pin_n) annotation(
        Line(points = {{-62, 0}, {-62, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.nv, oneFlange.pin_n) annotation(
        Line(points = {{-36, 20}, {-36, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -60}, {100, 60}}), graphics = {Text(origin = {2, -4}, textColor = {238, 46, 47}, extent = {{0, -24}, {78, -36}}, textString = "- around 70 kW, Max 700 Nm
        - Torque limits from file (rpm, Nm, doubled)
        - Loss formula", horizontalAlignment = TextAlignment.Left)}),
        experiment(StopTime = 50),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
        Documentation(info = "<html><head></head><body><p>Second simple test of model OneFlange.</p>
        <p>Siimilar to TestOneFlange1, but torque limits taken from a file (un-normalised).&nbsp;</p><p>Since the limits from file allow larger speeds to be reached (250 rpms instead of 210), loss formula parameters are changed to have comparable losses during the considered transient.</p><p>Suggesed plots are as per&nbsp;TestOneFlange1. Only, we note that here state is rather meaningless, since it is contantly equal to -1 as it should when limits are taken from file.</p><p>It is also useful to see oneFlange.limtau.yH versus inertia.w and see oneFlange.powSensor.power.yH versus inertia.w.</p><p><br></p>
        </body></html>"));
    end TestOneFlange3;

    model TestOneFlange4 "Tests OneFlange with torque limits from file (unNormalised) and loss formula"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 7, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
        Placement(transformation(extent = {{40, -10}, {60, 10}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -150, w_nominal = 250) annotation(
        Placement(transformation(extent = {{94, -10}, {74, 10}})));
      Modelica.Blocks.Sources.Trapezoid tauRef(rising = 5, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 450, offset = 10) annotation(
        Placement(transformation(extent = {{-58, -38}, {-38, -18}})));
      OneFlange oneFlange(powMax = 7e4, limitsOnFile = true, tauMax = 400, J = 0.2, wMax = 20.943951023931955, limitsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt"), tauLimitsMapName = "minMaxTorque", uDcNom = 400, efficiencyFromTable = true, bT = 0, bW = 0.003, bP = 0, A = 0.04, effMapOnFile = true, effTableName = "effTable", effMapFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt")) annotation(
        Placement(transformation(extent = {{-20, -10}, {0, 10}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 400) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-62, 10})));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(transformation(extent = {{-82, -20}, {-62, 0}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation(
        Placement(transformation(extent = {{14, -10}, {34, 10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
        Placement(transformation(extent = {{-46, 20}, {-26, 40}})));
    equation
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{60, 0}, {74, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(tauRef.y, oneFlange.tauRef) annotation(
        Line(points = {{-37, -28}, {-30, -28}, {-30, 0}, {-21.4, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(ground.p, gen.n) annotation(
        Line(points = {{-72, 0}, {-62, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(oneFlange.flange_a, powMech.flange_a) annotation(
        Line(points = {{0, 0}, {14, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_a, powMech.flange_b) annotation(
        Line(points = {{40, 0}, {34, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(powElec.nc, oneFlange.pin_p) annotation(
        Line(points = {{-26, 30}, {-20, 30}, {-20, 4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pc, gen.p) annotation(
        Line(points = {{-46, 30}, {-62, 30}, {-62, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pv, powElec.nc) annotation(
        Line(points = {{-36, 40}, {-26, 40}, {-26, 30}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(gen.n, oneFlange.pin_n) annotation(
        Line(points = {{-62, 0}, {-62, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.nv, oneFlange.pin_n) annotation(
        Line(points = {{-36, 20}, {-36, -4}, {-20, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -60}, {100, 60}}), graphics = {Text(origin = {2, -4}, textColor = {238, 46, 47}, extent = {{0, -24}, {78, -36}}, textString = "- around 70 kW, Max 700 Nm
    - Torque limits from file (rpm, Nm)
    - Efficiency from file", horizontalAlignment = TextAlignment.Left)}),
        experiment(StopTime = 50),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
        Documentation(info = "<html><head></head><body><p>Second simple test of model OneFlange.</p>
    <p>Siimilar to TestOneFlange1, but torque limits taken from a file (un-normalised).&nbsp;</p><p>Since the limits from file allow larger speeds to be reached (250 rpms instead of 210), loss formula parameters are changed to have comparable losses during the considered transient.</p><p>Suggesed plots are as per&nbsp;TestOneFlange1. Only, we note that here state is rather meaningless, since it is contantly equal to -1 as it should when limits are taken from file.</p><p>It is also useful to see oneFlange.limtau.yH versus inertia.w and see oneFlange.powSensor.power.yH versus inertia.w.</p><p><br></p>
    </body></html>"));
    end TestOneFlange4;

    model TestOneFlange1Conn "Tests OneFlange with fixed torque limits and loss formula"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 7, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
        Placement(transformation(extent = {{38, -10}, {58, 10}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(tau_nominal = -150, w_nominal = 250) annotation(
        Placement(transformation(extent = {{92, -10}, {72, 10}})));
      OneFlangeConn oneFlange(powMax(displayUnit = "kW") = 7e4, limitsOnFile = false, tauMax = 400, J = 0.2, wMax = 200, uDcNom = 400, efficiencyFromTable = false) annotation(
        Placement(transformation(extent = {{-24, -10}, {-4, 10}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 400) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-64, 10})));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(transformation(extent = {{-90, -20}, {-70, 0}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech annotation(
        Placement(transformation(extent = {{12, -10}, {32, 10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
        Placement(transformation(extent = {{-48, 20}, {-28, 40}})));
      Modelica.Blocks.Sources.Trapezoid tauRef(rising = 5, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 450, offset = 10) annotation(
        Placement(transformation(extent = {{-74, -48}, {-54, -28}})));
      SupportModels.ConnectorRelated.ToConnGenTauRef toConnGenTauNorm annotation(
        Placement(transformation(extent = {{-34, -44}, {-22, -32}})));
    equation
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{58, 0}, {72, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(ground.p, gen.n) annotation(
        Line(points = {{-80, 0}, {-64, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(oneFlange.flange_a, powMech.flange_a) annotation(
        Line(points = {{-4, 0}, {12, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_a, powMech.flange_b) annotation(
        Line(points = {{38, 0}, {32, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(powElec.nc, oneFlange.pin_p) annotation(
        Line(points = {{-28, 30}, {-24, 30}, {-24, 4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pc, gen.p) annotation(
        Line(points = {{-48, 30}, {-64, 30}, {-64, 20}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.pv, powElec.nc) annotation(
        Line(points = {{-38, 40}, {-28, 40}, {-28, 30}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(gen.n, oneFlange.pin_n) annotation(
        Line(points = {{-64, 0}, {-64, -4}, {-24, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(powElec.nv, oneFlange.pin_n) annotation(
        Line(points = {{-38, 20}, {-38, -4}, {-24, -4}}, color = {0, 0, 255}, smooth = Smooth.None));
      connect(toConnGenTauNorm.conn, oneFlange.conn) annotation(
        Line(points = {{-22.2, -38}, {-5, -38}, {-5, -7.8}}, color = {255, 204, 51}, thickness = 0.5));
      connect(tauRef.y, toConnGenTauNorm.u) annotation(
        Line(points = {{-53, -38}, {-35, -38}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 60}}), graphics = {Text(textColor = {238, 46, 47}, extent = {{16, -30}, {62, -40}}, textString = "- Fixed torque limits 
- Loss formula", horizontalAlignment = TextAlignment.Left)}),
        experiment(StopTime = 50),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
        Documentation(info = "<html>
    <p>This is a simple test of model OneFlange.</p>
    <p>It shows that the generated torque follows the normalised torque request as long as it does not overcome the allowed maximum. Actual torque will be this request times the maximum value that, in turn, is the minimum between tauMax and powerMax/w (while w is the rotational speed)</p>
    <p>It shows also the effects of efficiency on the DC power.</p>
    <p><u>First suggested plots</u>: on the same axis oneFlange.torque.tau, and tauRef vertically aligned with the previous oneFlange.limTau.state. In these plots it can be seen that:</p>
    <ul>
    <li>during the first 10 seconds the generated torque oneFlange.torque.tau, is 20Nm, as requested from the input. The maximum torque that can be generated is not limited by the power limit</li>
    <li>between t=10 and 13.4 s the generated torque continues to follow the input signal; </li>
    <li>between t=13.4 and 15.3 s, since the drive power has been reached (10 kW), the generated torque is automatically reduced to avoid this limit to be overcome </li>
    <li>above t=15.3 and below 18.4 s the torque request is limited by tauMax.</li>
    <li>above t=18.4 s and before 20 the torque request is limited by powMax.</li>
    <li>above t=20 and before 38 s the torque is limited by wmax</li>
    <li>above 38 s the torque request reduces, and thnon limit is active anymore</li>
    <li>All the above behaviour is confirmed by the value of boolean variable oneFlange.limTau.state.</li>
    </ul>
    <p><br><u>Second suggested plot</u>: Once the first plot is anaysed, the user might want to have an idea of the mechanical and electrical powers: these are seen putting in the same plot powMech.power and powElec.power.</p>
    </html>"));
    end TestOneFlange1Conn;
  end TestOneFlange;

  package TestICE
    model TestIceT "Test IceT"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true)) annotation(
        Placement(transformation(extent = {{14, -2}, {34, 18}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation(
        Placement(transformation(extent = {{68, -2}, {48, 18}})));
      Modelica.Blocks.Sources.Trapezoid trapezoid(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 50.0, amplitude = 35.0) annotation(
        Placement(transformation(extent = {{-46, -32}, {-26, -12}})));
      IceT iceT(wIceStart = 78.0, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/PSDmaps.txt"), specConsName = "iceSpecificCons", tlSpeedFactor = 1, scMapOnFile = true, tlMapOnFile = true, scSpeedFactor = 1) annotation(
        Placement(transformation(extent = {{-16, -2}, {4, 18}})));
    equation
      connect(iceT.flange_a, inertia.flange_a) annotation(
        Line(points = {{4, 8}, {14, 8}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{34, 8}, {48, 8}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(iceT.tauRef, trapezoid.y) annotation(
        Line(points = {{-12, -3.8}, {-12, -22}, {-25, -22}}, color = {0, 0, 127}, smooth = Smooth.None));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -40}, {80, 40}})),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-60, -60}, {80, 40}})),
        Documentation(info = "<html><head></head><body><p>This is a simple test of model IceT.</p>
    <p>It shows that the generated torque follows the torque request as long as the maximum allowed is not overcome; otherwise this maximum is generated.</p>
    <p>It shows also the fuel consumption output.</p>
    <p>The user can compare the torque request tauRef with the torque generated and at the ICE flange (in this transient the inertia torques are very small and can be neglected). The user could also have a look at the rotational speeds and fuel consumption. </p>
    <p>Fuel consumption (iceT.tokgFuel) can be evaluated mapsOnFile=true and mapsOnFile=false.&nbsp;</p><p>Variables torqueMultiplier, speedMultiplier and consMultiplier can be used to process read fuel consumption: this allows normalised tables to be used for several engines: changing these three variables scales the input map according to will. An example is in #####</p><p>Users are prompted to change some values on iceSpecificCons in file with maps (default PSDmaps.txt) and see the effects on iceT.tokgFuel.</p>
    </body></html>"),
        experiment(StopTime = 60, __Dymola_Algorithm = "Dassl"));
    end TestIceT;

    model TestIceT01 "Test IceT01"
      IceT01 iceT(wIceStart = 70.0, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/PSDmaps.txt"), specConsName = "iceSpecificCons") annotation(
        Placement(transformation(extent = {{-16, -2}, {4, 18}})));
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 5.0, phi(start = 0, fixed = true)) annotation(
        Placement(transformation(extent = {{14, -2}, {34, 18}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation(
        Placement(transformation(extent = {{68, -2}, {48, 18}})));
      Modelica.Blocks.Sources.Trapezoid trapezoid(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 0.5, amplitude = 0.3) annotation(
        Placement(transformation(extent = {{-46, -32}, {-26, -12}})));
    equation
      connect(iceT.flange_a, inertia.flange_a) annotation(
        Line(points = {{4, 8}, {14, 8}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{34, 8}, {48, 8}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(iceT.nTauRef, trapezoid.y) annotation(
        Line(points = {{-12, -2.2}, {-12, -22}, {-25, -22}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -40}, {80, 40}})),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-60, -60}, {80, 40}})),
        Documentation(info = "<html>
    <p>This is a simple test of model IceT.</p>
    <p>It shows that the generated torque follows the torque request as long as the maximum allowed is not overcome; otherwise this maximum is generated.</p>
    <p>It shows also the fuel consumption output.</p>
    <p>The user could compare the torque request tauRef with the torque generated and at the ICE flange (with this transient the inertia torques are very small and can be neglected). The user could also have a look at the rotational speeds and fuel consumption. </p>
    <p>The user can also use it with mapsOnFile=true and mapsOnFile=false, and check iceT.tokgFuel.</p>
    <p>They can change some values on iceSpecificCons in file with maps (default PSDmaps.txt) and see the effects on iceT.tokgFuel.</p>
    </html>"),
        experiment(StopTime = 60, __Dymola_Algorithm = "Dassl"));
    end TestIceT01;

    model TestIceP "Test IceP"
      IceP iceP(contrGain = 1, wIceStart = 80, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/PSDmaps.txt"), specConsName = "iceSpecificCons") annotation(
        Placement(transformation(extent = {{-22, -2}, {-2, 18}})));
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true)) annotation(
        Placement(transformation(extent = {{28, -2}, {48, 18}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation(
        Placement(transformation(extent = {{76, -2}, {56, 18}})));
      Modelica.Blocks.Sources.Trapezoid trapezoid(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 4000, amplitude = 2000) annotation(
        Placement(transformation(extent = {{-52, -30}, {-32, -10}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor pow annotation(
        Placement(transformation(extent = {{4, -2}, {24, 18}})));
    equation
      connect(inertia.flange_b, loadTorque.flange) annotation(
        Line(points = {{48, 8}, {56, 8}}, color = {0, 0, 0}, smooth = Smooth.None));
//    experiment(StopTime = 50),
      connect(iceP.powRef, trapezoid.y) annotation(
        Line(points = {{-18, -4}, {-18, -20}, {-31, -20}}, color = {0, 0, 127}));
      connect(iceP.flange_a, pow.flange_a) annotation(
        Line(points = {{-2, 8}, {4, 8}}, color = {0, 0, 0}));
      connect(inertia.flange_a, pow.flange_b) annotation(
        Line(points = {{28, 8}, {24, 8}}, color = {0, 0, 0}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -40}, {80, 40}})),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-60, -60}, {80, 40}})),
        Documentation(info = "<html>
    <p>This is a simple test of model IceP.</p>
    <p>It shows that the generated power follows the power request with some error: the internal control loop ii simply proportional. TRo reduce steaady-steate error, better would be to use a PI controller.</p>
    <p>It shows also the fuel consumption output.</p>
    <p>The user could compare the torque power powRef with the power delivered generated and at the ICE flange (with this transient the inertia torques are very small and can be neglected). The user could also have a look at the rotational speeds and fuel consumption. </p>
    <p>Users can also use it with mapsOnFile=true and mapsOnFile=false, and check iceT.tokgFuel.</p>
    <p>They can change some values on iceSpecificCons in file with maps (default PSDmaps.txt) and see the effects on iceT.tokgFuel.</p>
    <p>The power request is 4-6 kW, which is reasonable, since the nominal load is 80Nm at 100 rad/s, which corresponds to 8 kW.</p>
    </html>"),
        experiment(StopTime = 60, __Dymola_Algorithm = "Dassl"));
    end TestIceP;

    model TestIceConn "Test IceConn"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(phi(start = 0, fixed = true), J = 10) annotation(
        Placement(transformation(extent = {{-14, 0}, {6, 20}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation(
        Placement(transformation(extent = {{64, 0}, {44, 20}})));
      IceConnP ice(contrGain = 0.5, wIceStart = 90, mapsFileName = "PSDmaps.txt") annotation(
        Placement(transformation(extent = {{-42, 0}, {-22, 20}})));
      SupportModels.ConnectorRelated.ToConnIcePowRef toConnIceTauRef annotation(
        Placement(transformation(extent = {{-6, -6}, {6, 6}}, rotation = 90, origin = {-32, -18})));
      Modelica.Blocks.Sources.Trapezoid powReq(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 60, amplitude = 10e3) annotation(
        Placement(transformation(extent = {{-74, -30}, {-54, -10}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor outPow annotation(
        Placement(transformation(extent = {{18, 0}, {38, 20}})));
    equation
      connect(inertia.flange_a, ice.flange_a) annotation(
        Line(points = {{-14, 10}, {-22, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(toConnIceTauRef.conn, ice.conn) annotation(
        Line(points = {{-32, -12}, {-32, -0.2}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None));
      connect(toConnIceTauRef.u, powReq.y) annotation(
        Line(points = {{-32, -25.4}, {-32, -32}, {-44, -32}, {-44, -20}, {-53, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(inertia.flange_b, outPow.flange_a) annotation(
        Line(points = {{6, 10}, {18, 10}}, color = {0, 0, 0}));
      connect(loadTorque.flange, outPow.flange_b) annotation(
        Line(points = {{44, 10}, {38, 10}}, color = {0, 0, 0}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -40}, {80, 40}})),
        experiment(StopTime = 50),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-80, -60}, {80, 60}})),
        Documentation(info = "<html>
    <p>This is a simple test of model IceConn, loaded with a huge inertia and a quadratic dependent load torque.</p>
    <p>It shows that the generated power (variable icePowDel inside connectors and bus) follows the power request. The load power outPow.Power differs from the generated power due to the large inertia in-between. If closer matching between icePowDel and powReq.y is wanted the ice inner control gain contrGain can be raised.</p>
    <p>It shows also the fuel consumption output. The user could also have a look at the rotational speed. </p>
    </html>"));
    end TestIceConn;

    model TestIceConnOO "Test IceConnOO"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(phi(start = 0, fixed = true), J = 10) annotation(
        Placement(transformation(extent = {{-14, 0}, {6, 20}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation(
        Placement(transformation(extent = {{64, 0}, {44, 20}})));
      IceConnPOO ice(contrGain = 0.5, wIceStart = 80, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/PSDmaps.txt")) annotation(
        Placement(transformation(extent = {{-42, 0}, {-22, 20}})));
      SupportModels.ConnectorRelated.ToConnIcePowRef toConnIceTauRef annotation(
        Placement(transformation(extent = {{-6, -6}, {6, 6}}, rotation = 90, origin = {-32, -18})));
      Modelica.Blocks.Sources.Trapezoid powReq(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 4000, amplitude = 2000) annotation(
        Placement(transformation(extent = {{-74, -30}, {-54, -10}})));
      Modelica.Mechanics.Rotational.Sensors.PowerSensor outPow annotation(
        Placement(transformation(extent = {{18, 0}, {38, 20}})));
      SupportModels.ConnectorRelated.ToConnIceON toConnIceON annotation(
        Placement(transformation(extent = {{-6, -6}, {6, 6}}, rotation = 90, origin = {-16, -18})));
      Modelica.Blocks.Sources.BooleanStep stepOn(startTime = 25, startValue = true) annotation(
        Placement(transformation(extent = {{74, -20}, {60, -6}})));
      Modelica.Blocks.Sources.BooleanStep stepOff(startTime = 30, startValue = false) annotation(
        Placement(transformation(extent = {{54, -36}, {40, -22}})));
      Modelica.Blocks.Logical.Or or1 annotation(
        Placement(transformation(extent = {{26, -32}, {10, -16}})));
    equation
      connect(inertia.flange_a, ice.flange_a) annotation(
        Line(points = {{-14, 10}, {-22, 10}}, color = {0, 0, 0}, smooth = Smooth.None));
      connect(toConnIceTauRef.conn, ice.conn) annotation(
        Line(points = {{-32, -12}, {-32, 0.2}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None));
      connect(toConnIceTauRef.u, powReq.y) annotation(
        Line(points = {{-32, -25.4}, {-32, -32}, {-44, -32}, {-44, -20}, {-53, -20}}, color = {0, 0, 127}, smooth = Smooth.None));
      connect(inertia.flange_b, outPow.flange_a) annotation(
        Line(points = {{6, 10}, {18, 10}}, color = {0, 0, 0}));
      connect(loadTorque.flange, outPow.flange_b) annotation(
        Line(points = {{44, 10}, {38, 10}}, color = {0, 0, 0}));
      connect(toConnIceON.conn, ice.conn) annotation(
        Line(points = {{-16, -12}, {-16, -6}, {-32, -6}, {-32, 0.2}}, color = {255, 204, 51}, thickness = 0.5));
      connect(stepOn.y, or1.u1) annotation(
        Line(points = {{59.3, -13}, {27.6, -13}, {27.6, -24}}, color = {255, 0, 255}));
      connect(stepOff.y, or1.u2) annotation(
        Line(points = {{39.3, -29}, {39.3, -30.4}, {27.6, -30.4}}, color = {255, 0, 255}));
      connect(or1.y, toConnIceON.u) annotation(
        Line(points = {{9.2, -24}, {2, -24}, {2, -32}, {-16, -32}, {-16, -26}}, color = {255, 0, 255}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-80, -40}, {80, 40}})),
        experiment(StopTime = 60, __Dymola_Algorithm = "Dassl"),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-80, -60}, {80, 60}})),
        Documentation(info = "<html>
    <p>This is a simple test of model IceConnPOO, loaded with a huge inertia and a quadratic dependent load torque.</p>
    <p>It addition to testIceConn, it shows also that the model responds properly to On/Off requests.</p>
    </html>"));
    end TestIceConnOO;

    model TestIceTmultipliers "Test IceT"
      Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true)) annotation(
        Placement(transformation(origin = {-2, 16}, extent = {{14, -2}, {34, 18}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 100, tau_nominal = -80) annotation(
        Placement(transformation(origin = {0, 16}, extent = {{68, -2}, {48, 18}})));
      Modelica.Blocks.Sources.Trapezoid tauRef(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, offset = 50.0, amplitude = 35.0) annotation(
        Placement(transformation(origin = {-8, 22}, extent = {{-46, -32}, {-26, -12}})));
      IceT iceT(wIceStart = 78.0, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/PSDmaps.txt"), specConsName = "iceSpecificCons", tlSpeedFactor = 1, scMapOnFile = true, tlMapOnFile = true, scSpeedFactor = 1) annotation(
        Placement(transformation(origin = {-2, 16}, extent = {{-16, -2}, {4, 18}})));
      Modelica.Mechanics.Rotational.Components.Inertia inertia1(J = 0.5, phi(fixed = true, start = 0)) annotation(
        Placement(transformation(origin = {0, -28}, extent = {{14, -2}, {34, 18}})));
      IceT iceT1(mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/PSDmaps.txt"), scMapOnFile = true, scSpeedFactor = 1, specConsName = "iceSpecificCons", tlMapOnFile = true, tlSpeedFactor = 1, wIceStart = 78.0, scTorqueFactor = 1, tlTorqueFactor = 0.8, scConsFactor = 1.5) annotation(
        Placement(transformation(origin = {2, -28}, extent = {{-16, -2}, {4, 18}})));
      Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque1(tau_nominal = -80, w_nominal = 100) annotation(
        Placement(transformation(origin = {0, -28}, extent = {{68, -2}, {48, 18}})));
    equation
      connect(iceT.flange_a, inertia.flange_a) annotation(
        Line(points = {{2, 24}, {12, 24}}));
      connect(iceT.tauRef, tauRef.y) annotation(
        Line(points = {{-14, 12.2}, {-14, 0}, {-33, 0}}, color = {0, 0, 127}));
      connect(iceT1.flange_a, inertia1.flange_a) annotation(
        Line(points = {{6, -20}, {14, -20}}));
      connect(iceT1.tauRef, tauRef.y) annotation(
        Line(points = {{-10, -32}, {-10, -34}, {-20, -34}, {-20, 0}, {-33, 0}}, color = {0, 0, 127}));
      connect(inertia1.flange_b, loadTorque1.flange) annotation(
        Line(points = {{34, -20}, {48, -20}}));
      connect(loadTorque.flange, inertia.flange_b) annotation(
        Line(points = {{48, 24}, {32, 24}}));
      annotation(
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-60, -40}, {80, 40}})),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(extent = {{-60, -60}, {80, 40}})),
        Documentation(info = "<html><head></head><body><p>This model shows some effect of map multipliers.&nbsp;</p><p>In the powerline below, max torque multiplied by 0.8, and therefore more torque limitation occurs. Moreover, specific consumption is multiplied by 1.5.</p><p>It is suggested to check obtained torque vs max torque in the above and below powerlines, and to compare toG_perkWh of the two power lines.&nbsp;</p>
    </body></html>"),
        experiment(StopTime = 60, __Dymola_Algorithm = "Dassl"));
    end TestIceTmultipliers;
  end TestICE;

  package TestGensets
  
  
    model TestGenset1 "Ice, Generator, DriveTrain, all map-based"
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
      Placement(transformation(extent = {{-8, -8}, {8, 8}}, origin = {2, -26})));
    MapBased.Genset genset(gsRatio = 1, maxGenW = 300, maxGenPow = 55e3, maxTau = 550, wIceStart = 95, mapsOnFile = false) annotation(
      Placement(transformation(origin = {44, -24}, extent = {{-80, 8}, {-50, 38}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor gsPow annotation(
      Placement(transformation(origin = {44, -24}, extent = {{-32, 24}, {-12, 44}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage uDC(V = 100) annotation(
      Placement(transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.Trapezoid powerRef(amplitude = 20e3, rising = 1, width = 1, falling = 1, offset = 40e3, period = 10, startTime = 1) annotation(
      Placement(transformation(origin = {-60, 24}, extent = {{-10, -10}, {10, 10}})));
  equation
    connect(gsPow.nv, genset.pin_n) annotation(
      Line(points = {{22, 0}, {22, 0}, {22, -10}, {-5.7, -10}, {-5.7, -10}}, color = {0, 0, 255}));
    connect(gsPow.pv, gsPow.pc) annotation(
      Line(points = {{22, 20}, {12, 20}, {12, 10}}, color = {0, 0, 255}));
    connect(gsPow.pc, genset.pin_p) annotation(
      Line(points = {{12, 10}, {3, 10}, {3, 8}, {-6, 8}}, color = {0, 0, 255}));
    connect(genset.pin_n, ground1.p) annotation(
      Line(points = {{-5.7, -10}, {2, -10}, {2, -18}}, color = {0, 0, 255}));
    connect(gsPow.nc, uDC.p) annotation(
      Line(points = {{32, 10}, {48, 10}}, color = {0, 0, 255}));
    connect(uDC.n, genset.pin_n) annotation(
      Line(points = {{48, -10}, {-5.7, -10}}, color = {0, 0, 255}));
    connect(powerRef.y, genset.powRef) annotation(
      Line(points = {{-49, 24}, {-12.45, 24}, {-12.45, 16.25}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(extent = {{-80, 40}, {60, -40}}, initialScale = 0.1)),
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics),
      experiment(StopTime = 5, StartTime = 0, Tolerance = 1e-06, Interval = 0.005),
      Documentation(info = "<html><head></head><body><p>This is a first model testing the behaviour of Genset when nothing is taken from file.</p><p>Therefore it has:</p><p>- fixed torque limits</p><p>- fixed reference ICE speed</p><p>- fixed fuel consumption</p><p>- fixed generator efficiency.</p><p>It is highly unrealistic. The user can, however, use variable values of the above fixed limtits, taking advantage of the possibilities offered by their internal definition as matrices. However, the maximum flexibilithy is obtained when maps are on file, a behaviour which is checked with TestGenset2 model.</p>
  </body></html>"));
  end TestGenset1;

  model TestGenset2 "Ice, Generator, DriveTrain, all map-based"
    Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
      Placement(transformation(extent = {{-8, -8}, {8, 8}}, origin = {2, -26})));
    MapBased.Genset genset(
      gsRatio = 1,
      mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/SHEVmaps.txt"),
      maxGenW = 300,
      maxGenPow = 55e3,
      maxTau = 500,
      wIceStart = 114, efficiencyName = "gensetDriveEffTable", eTorqueFactor = 1/500, eSpeedFactor = 1/300) annotation(
      Placement(transformation(origin = {44, -24}, extent = {{-80, 8}, {-50, 38}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor gsPow annotation(
      Placement(transformation(origin = {44, -24}, extent = {{-32, 24}, {-12, 44}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage uDC(V = 100) annotation(
      Placement(transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = 20e3, rising = 1, width = 1, falling = 1, offset = 40e3, period = 10, startTime = 1) annotation(
      Placement(transformation(origin = {-60, 24}, extent = {{-10, -10}, {10, 10}})));
  equation
    connect(gsPow.nv, genset.pin_n) annotation(
      Line(points = {{22, 0}, {22, 0}, {22, -10}, {-5.7, -10}, {-5.7, -10}}, color = {0, 0, 255}));
    connect(gsPow.pv, gsPow.pc) annotation(
      Line(points = {{22, 20}, {12, 20}, {12, 10}}, color = {0, 0, 255}));
    connect(gsPow.pc, genset.pin_p) annotation(
      Line(points = {{12, 10}, {3, 10}, {3, 8}, {-6, 8}}, color = {0, 0, 255}));
    connect(genset.pin_n, ground1.p) annotation(
      Line(points = {{-5.7, -10}, {2, -10}, {2, -18}}, color = {0, 0, 255}));
    connect(gsPow.nc, uDC.p) annotation(
      Line(points = {{32, 10}, {48, 10}}, color = {0, 0, 255}));
    connect(uDC.n, genset.pin_n) annotation(
      Line(points = {{48, -10}, {-5.7, -10}}, color = {0, 0, 255}));
    connect(trapezoid.y, genset.powRef) annotation(
      Line(points = {{-49, 24}, {-12.45, 24}, {-12.45, 16.25}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(extent = {{-80, 40}, {60, -40}}, initialScale = 0.1)),
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics),
      experiment(StopTime = 5, StartTime = 0, Tolerance = 1e-06, Interval = 0.005),
      Documentation(info = "<html><head></head><body><p>This is model tests some of the genset features; it makes useage of maps on file.</p>
<p>The power request will not be entirely delivered by the DC terminals because of two reasons:</p>
<p>1. the requested power is the one delivered by the internal ICE, larger than the electrical power delivered by the internal generator, because the latter has, in general, a lower than one efficiency.</p>
<p>2. maximum DC power is also limited by parameter maxGenPow: in this simulation this limit is set to 55 kW and occurs 0.73 and 2.2 s.</p>
<p>To see this you can simultaneously plot  trapezoid.y, genset.icePow.power, gsPow.power.</p>
</body></html>"));
  end TestGenset2;

  model TestGensetOO "Ice, Generator, DriveTrain, all map-based"
    Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
      Placement(transformation(extent = {{-8, -8}, {8, 8}}, origin = {2, -30})));
    MapBased.GensetOO genset(gsRatio = 1, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/SHEVmaps.txt"), maxGenW = 300, maxGenPow = 55e3, maxTau = 500, wIceStart = 114) annotation(
      Placement(transformation(origin = {44, -30}, extent = {{-80, 8}, {-50, 38}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor gsPow annotation(
      Placement(transformation(origin = {44, -30}, extent = {{-32, 24}, {-12, 44}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage uDC(V = 100) annotation(
      Placement(transformation(origin = {48, -6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = 20e3, rising = 1, width = 1, falling = 1, offset = 40e3, period = 10, startTime = 1) annotation(
      Placement(transformation(origin = {12, 38}, extent = {{10, -10}, {-10, 10}})));
    Modelica.Blocks.Sources.BooleanStep booleanStep(startTime = 4, startValue = true) annotation(
      Placement(transformation(extent = {{-72, 28}, {-52, 48}})));
  equation
    connect(gsPow.nv, genset.pin_n) annotation(
      Line(points = {{22, -6}, {22, -16}, {-5.7, -16}}, color = {0, 0, 255}));
    connect(gsPow.pv, gsPow.pc) annotation(
      Line(points = {{22, 14}, {12, 14}, {12, 4}}, color = {0, 0, 255}));
    connect(gsPow.pc, genset.pin_p) annotation(
      Line(points = {{12, 4}, {3, 4}, {3, 2}, {-6, 2}}, color = {0, 0, 255}));
    connect(genset.pin_n, ground1.p) annotation(
      Line(points = {{-5.7, -16}, {2, -16}, {2, -22}}, color = {0, 0, 255}));
    connect(gsPow.nc, uDC.p) annotation(
      Line(points = {{32, 4}, {48, 4}}, color = {0, 0, 255}));
    connect(uDC.n, genset.pin_n) annotation(
      Line(points = {{48, -16}, {-5.7, -16}}, color = {0, 0, 255}));
    connect(trapezoid.y, genset.powRef) annotation(
      Line(points = {{1, 38}, {-12.45, 38}, {-12.45, 10.25}}, color = {0, 0, 127}));
    connect(booleanStep.y, genset.ON) annotation(
      Line(points = {{-51, 38}, {-30, 38}, {-30, 10.4}}, color = {255, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-80, 60}, {60, -40}})),
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-80, 60}, {60, -40}}), graphics),
      experiment(StopTime = 8, Interval = 0.005, Tolerance = 1e-06, __Dymola_Algorithm = "Dassl"),
      Documentation(info = "<html>
<p>This is like TestGenset, but at t=4s genset is put Off by use of its logical input.</p>
<p>Output power and torque at the internal machines (ICE and gen) go to zero.</p>
</html>"));
  end TestGensetOO;
  end TestGensets;

  model TestLimTorque
    import Modelica.Constants.pi;
    SupportModels.MapBasedRelated.LimTorque fixedLimits(tauMax = 700, powMax(displayUnit = "kW") = 7e4) annotation(
      Placement(transformation(origin = {2, 32}, extent = {{-10, -10}, {10, 10}})));
    SupportModels.MapBasedRelated.LimTorque fileTxtLimits(limitsOnFile = true, limitsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt"), limitsTableName = "minMaxTorque") annotation(
      Placement(transformation(origin = {18, -4}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Sources.Ramp radsPerSec(height = 200, duration = 3, offset = 20, startTime = 1) annotation(
      Placement(transformation(origin = {-58, -4}, extent = {{-10, -10}, {10, 10}})));
    EHPTlib.SupportModels.Miscellaneous.Gain toPuSpeed(k = 60/(2*pi)) annotation(
      Placement(transformation(origin = {-10, -4}, extent = {{8, -8}, {-8, 8}}, rotation = -180)));
  equation
    connect(fixedLimits.w, radsPerSec.y) annotation(
      Line(points = {{-10, 32}, {-32, 32}, {-32, -4}, {-47, -4}}, color = {0, 0, 127}));
    connect(toPuSpeed.u, radsPerSec.y) annotation(
      Line(points = {{-19.6, -4}, {-47, -4}}, color = {0, 0, 127}));
    connect(toPuSpeed.y, fileTxtLimits.w) annotation(
      Line(points = {{-1.2, -4}, {6, -4}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html><head></head><body>Tests torque limits in various conditions: fixed limits, from text file normalised, from text file un-normalised.<br></body></html>"),
      Diagram(coordinateSystem(extent = {{-80, 60}, {60, -40}})),
      experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.01));
  end TestLimTorque;

  model TestTwoFlange1 "Test of TwoFlange drive train model"
    import Modelica.Constants.pi;
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
      Placement(transformation(extent = {{38, -10}, {58, 10}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 400, tau_nominal = -50.0) annotation(
      Placement(transformation(extent = {{92, -10}, {72, 10}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 100) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-60, 28})));
    Modelica.Electrical.Analog.Basic.Ground ground annotation(
      Placement(transformation(extent = {{-100, -2}, {-80, 18}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech2 annotation(
      Placement(transformation(extent = {{12, -10}, {32, 10}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
      Placement(transformation(extent = {{-48, 32}, {-28, 52}})));
    TwoFlange twoFlanges(J = 0.5, wMax = 300, tauMax = 60, powMax = 22000, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt"), effTableName = "effTable", mapsOnFile = false) annotation(
      Placement(transformation(extent = {{-18, -10}, {2, 10}})));
    Modelica.Mechanics.Rotational.Sources.ConstantTorque tau1(tau_constant = -5.0) annotation(
      Placement(transformation(extent = {{-76, -10}, {-56, 10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech1 annotation(
      Placement(transformation(extent = {{-28, -10}, {-48, 10}})));
    Modelica.Blocks.Sources.Trapezoid tauRef(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 50, offset = 20) annotation(
      Placement(transformation(origin = {-26, -2}, extent = {{-40, -48}, {-20, -28}})));
    Modelica.Blocks.Math.Add toTotPmecc annotation(
      Placement(transformation(origin = {44, -34}, extent = {{-10, -10}, {10, 10}})));
  equation
    connect(inertia.flange_b, loadTorque.flange) annotation(
      Line(points = {{58, 0}, {72, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(ground.p, gen.n) annotation(
      Line(points = {{-90, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(inertia.flange_a, powMech2.flange_b) annotation(
      Line(points = {{38, 0}, {32, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.pc, gen.p) annotation(
      Line(points = {{-48, 42}, {-60, 42}, {-60, 38}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.pv, powElec.nc) annotation(
      Line(points = {{-38, 52}, {-28, 52}, {-28, 42}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powMech2.flange_a, twoFlanges.flange_b) annotation(
      Line(points = {{12, 0}, {8, 0}, {8, -0.2}, {2, -0.2}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.nc, twoFlanges.pin_n) annotation(
      Line(points = {{-28, 42}, {-4, 42}, {-4, 8.2}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(twoFlanges.pin_p, gen.n) annotation(
      Line(points = {{-12, 8.2}, {-12, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.nv, gen.n) annotation(
      Line(points = {{-38, 32}, {-38, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(twoFlanges.flange_a, powMech1.flange_a) annotation(
      Line(points = {{-18, 0}, {-28, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tau1.flange, powMech1.flange_b) annotation(
      Line(points = {{-56, 0}, {-48, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tauRef.y, twoFlanges.tauRef) annotation(
      Line(points = {{-45, -40}, {-10, -40}, {-10, -9.2}, {-8, -9.2}}, color = {0, 0, 127}));
    connect(powMech1.power, toTotPmecc.u1) annotation(
      Line(points = {{-30, -10}, {-30, -28}, {32, -28}}, color = {0, 0, 127}));
    connect(toTotPmecc.u2, powMech2.power) annotation(
      Line(points = {{32, -40}, {14, -40}, {14, -10}}, color = {0, 0, 127}));
    annotation(
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
  end TestTwoFlange1;

  model TestTwoFlange2 "Test of TwoFlange drive train model"
    import Modelica.Constants.pi;
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.5, phi(start = 0, fixed = true), w(start = 50, fixed = true)) annotation(
      Placement(transformation(extent = {{38, -10}, {58, 10}})));
    Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque loadTorque(w_nominal = 400, tau_nominal = -50.0) annotation(
      Placement(transformation(extent = {{92, -10}, {72, 10}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage gen(V = 100) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {-60, 28})));
    Modelica.Electrical.Analog.Basic.Ground ground annotation(
      Placement(transformation(extent = {{-100, -2}, {-80, 18}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech2 annotation(
      Placement(transformation(extent = {{12, -10}, {32, 10}})));
    Modelica.Electrical.Analog.Sensors.PowerSensor powElec annotation(
      Placement(transformation(extent = {{-48, 32}, {-28, 52}})));
    TwoFlange twoFlanges(J = 0.5, wMax = 300, tauMax = 60, powMax = 22000, mapsFileName = Modelica.Utilities.Files.loadResource("modelica://EHPTlib/Resources/EVmapsNew.txt"), effTableName = "effTable", mapsOnFile = true, eSpeedFactor = 0.6*60/(2*pi)) annotation(
      Placement(transformation(extent = {{-18, -10}, {2, 10}})));
    Modelica.Mechanics.Rotational.Sources.ConstantTorque tau1(tau_constant = -5.0) annotation(
      Placement(transformation(extent = {{-76, -10}, {-56, 10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powMech1 annotation(
      Placement(transformation(extent = {{-28, -10}, {-48, 10}})));
    Modelica.Blocks.Sources.Trapezoid tauRef(rising = 10, width = 10, falling = 10, period = 1e6, startTime = 10, amplitude = 50, offset = 20) annotation(
      Placement(transformation(origin = {-26, -2}, extent = {{-40, -48}, {-20, -28}})));
    Modelica.Blocks.Math.Add toTotPmecc annotation(
      Placement(transformation(origin = {44, -34}, extent = {{-10, -10}, {10, 10}})));
  equation
    connect(inertia.flange_b, loadTorque.flange) annotation(
      Line(points = {{58, 0}, {72, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(ground.p, gen.n) annotation(
      Line(points = {{-90, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(inertia.flange_a, powMech2.flange_b) annotation(
      Line(points = {{38, 0}, {32, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.pc, gen.p) annotation(
      Line(points = {{-48, 42}, {-60, 42}, {-60, 38}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.pv, powElec.nc) annotation(
      Line(points = {{-38, 52}, {-28, 52}, {-28, 42}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powMech2.flange_a, twoFlanges.flange_b) annotation(
      Line(points = {{12, 0}, {8, 0}, {8, -0.2}, {2, -0.2}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(powElec.nc, twoFlanges.pin_n) annotation(
      Line(points = {{-28, 42}, {-4, 42}, {-4, 8.2}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(twoFlanges.pin_p, gen.n) annotation(
      Line(points = {{-12, 8.2}, {-12, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(powElec.nv, gen.n) annotation(
      Line(points = {{-38, 32}, {-38, 18}, {-60, 18}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(twoFlanges.flange_a, powMech1.flange_a) annotation(
      Line(points = {{-18, 0}, {-28, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tau1.flange, powMech1.flange_b) annotation(
      Line(points = {{-56, 0}, {-48, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(tauRef.y, twoFlanges.tauRef) annotation(
      Line(points = {{-45, -40}, {-10, -40}, {-10, -9.2}, {-8, -9.2}}, color = {0, 0, 127}));
    connect(powMech1.power, toTotPmecc.u1) annotation(
      Line(points = {{-30, -10}, {-30, -28}, {32, -28}}, color = {0, 0, 127}));
    connect(toTotPmecc.u2, powMech2.power) annotation(
      Line(points = {{32, -40}, {14, -40}, {14, -10}}, color = {0, 0, 127}));
    annotation(
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
  end TestTwoFlange2;


end TestingModels;
