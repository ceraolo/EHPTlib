within EHPTlib.MapBased;
package Partial
  partial model PartialOneFlange "Partial map-based one-Flange electric drive model"
    import Modelica.Constants.*;
    Boolean limitingTorque;
    
    //Alias variables:
    Modelica.Units.SI.Torque tauElectrical=torque.tau;
    Modelica.Units.SI.AngularVelocity wMechanical=wSensor.w;
    
    parameter Modelica.Units.SI.MomentOfInertia J = 0.25 "Rotor's moment of inertia" annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.Voltage uDcNom = 100 "Nominal DC voltage" annotation(
      Dialog(group = "General parameters"));
    parameter Boolean limitsOnFile = false "= true, if torque and speed limits are taken from a txt file, otherwise they are tauMax and wMax" annotation(
//      choices(checkBox = true),
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.AngularVelocity wMax = 3000 "Maximum speed (for efficiency and torque limitation when limitsOnFile=false)" annotation(
      Dialog(group = "General parameters", enable=not limitsOnFile));
    parameter Real tlTorqueFactor=1 "factor applied to input torque for limits they are from file" annotation(
      Dialog(group = "Torque limitation related parameters", enable=limitsOnFile));
    parameter Real tlSpeedFactor=60/(2*pi) "factor applied to input speed for limits when they are from file"
                                 annotation(
      Dialog(group = "Torque limitation related parameters", enable=limitsOnFile));
    parameter Modelica.Units.SI.Power powMax = 22000 "Maximum mechanical power (used for efficiency and torque limitation when limitsOnFile=false)" annotation(
      Dialog(group = "General parameters", enable=not limitsOnFile));
    //Parameters related to torque limits:
    parameter Modelica.Units.SI.Torque tauMax = 80 "Maximum torque when limitsOnFile=false" annotation(
      Dialog(group = "General parameters", enable= not limitsOnFile));
    parameter String limitsFileName = "noName" "File where efficiency table matrix is stored" annotation(
      Dialog(group = "Torque limitation related parameters", enable = limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String tauLimitsMapName = "noName" "Name of the on-file lower torque limit" annotation(
      Dialog(enable = limitsOnFile, group = "Torque limitation related parameters"));
    //Parameters related to efficiency combi table:
    parameter Boolean efficiencyFromTable = true "=true if efficiency if from a table (either online or from a file); otherwise use a the built-in loss formula" annotation(
      choices(checkBox = true),
      Dialog(group = "Efficiency related parameters"));
    parameter Boolean effMapOnFile = false "= true, if tables are taken from a txt file" annotation(
      choices(checkBox = true),
      Dialog(enable = efficiencyFromTable, group = "Efficiency related parameters"));
    parameter String effMapFileName = "noName" "File where efficiency table matrix is stored" annotation(
      Dialog(group = "Efficiency related parameters", enable = effMapOnFile and efficiencyFromTable, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter Real eTorqueFactor=1 "factor applied to input torque for efficiencies when they are from file"
                                annotation(
      Dialog(group = "Efficiency related parameters", enable=effMapOnFile));
    parameter Real eSpeedFactor=60/(2*pi) "factor applied to input speed for efficiencies when they are from file"
                                annotation(
      Dialog(group = "Efficiency related parameters", enable=effMapOnFile));
    parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation(
      Dialog(enable = effMapOnFile and efficiencyFromTable, group = "Efficiency related parameters"));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both PU of wMax and tauMax" annotation(
      Dialog(enable = not effMapOnFile and efficiencyFromTable, group = "Efficiency related parameters"));
    //Parameters related to the loss-formula:
    parameter Real A = 0.006 "fixed losses" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    parameter Real bT = 0.05 "torque losses coefficient" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    parameter Real bW = 0.02 "speed losses coefficient" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));
    parameter Real bP = 0.05 "power losses coefficient" annotation(
      Dialog(enable = not efficiencyFromTable, group = "Loss-formula parameters"));

    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(
      Placement(transformation(extent = {{88, 50}, {108, 70}}, rotation = 0), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation(
      Placement(transformation(extent = {{8, -8}, {-8, 8}}, rotation = 90, origin = {84, 44})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(extent = {{-110, 30}, {-90, 50}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(extent = {{-110, -50}, {-90, -30}})));
    SupportModels.MapBasedRelated.ConstPg pDC(vNom = uDcNom) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-88, 0})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation(
      Placement(transformation(extent = {{48, 50}, {68, 70}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
      Placement(transformation(extent = {{-16, 50}, {4, 70}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powSensor annotation(
      Placement(transformation(extent = {{18, 50}, {38, 70}})));
    Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
      Placement(transformation(extent = {{-28, 20}, {-48, 40}})));
    SupportModels.MapBasedRelated.LimTorque limTau(limitsOnFile = limitsOnFile, tauMax = tauMax, wMax = wMax, powMax = powMax, limitsFileName = limitsFileName, limitsTableName = tauLimitsMapName) annotation(
      Placement(transformation(extent = {{50, -2}, {30, 22}})));
    SupportModels.Miscellaneous.Gain fromPuTorque(k = tlTorqueFactor_) annotation(
      Placement(visible = true, transformation(origin = {14, 30}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
    SupportModels.Miscellaneous.Gain fromPuTorque1(k = tlTorqueFactor_) annotation(
      Placement(visible = true, transformation(origin = {14, 2}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
    SupportModels.Miscellaneous.Gain toPuSpeed(k = tlSpeedFactor_) annotation(
      Placement(visible = true, transformation(origin = {68, 10}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
    SupportModels.MapBasedRelated.EfficiencyCT toElePow(mapOnFile = effMapOnFile, tauFactor=eTorqueFactor, speedFactor=eSpeedFactor, mapFileName = effMapFileName, effTableName = effTableName, effTable = effTable) if efficiencyFromTable annotation(
      Placement(transformation(extent = {{-38, -34}, {-58, -14}})));
    SupportModels.MapBasedRelated.EfficiencyLF toElePow1(A = A, bT = bT, bW = bW, bP = bP, tauMax = tauMax, powMax = powMax, wMax = wMax) if not efficiencyFromTable annotation(
      Placement(transformation(extent = {{-38, -56}, {-58, -36}})));
    final parameter Real tlTorqueFactor_( fixed=false);
    final parameter Real tlSpeedFactor_( fixed=false);
    final parameter Real eTorqueFactor_( fixed=false);
    final parameter Real eSpeedFactor_( fixed=false);
  initial equation
    if limitsOnFile then
      tlTorqueFactor_ = tlTorqueFactor;
      tlSpeedFactor_ = tlSpeedFactor;
      eTorqueFactor_ = eTorqueFactor;
      eSpeedFactor_  = eSpeedFactor;
    else
      tlTorqueFactor_ = 1;
      tlSpeedFactor_ = 1;
      eTorqueFactor_ = 1;
      eSpeedFactor_  = 1;
    end if;
  equation
    if abs(variableLimiter.y - variableLimiter.u) > 1e-15 then
      limitingTorque = true;
    else
      limitingTorque = false;
    end if;
    connect(pin_p, pDC.pin_p) annotation(
      Line(points = {{-100, 40}, {-100, 24}, {-88, 24}, {-88, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(pin_n, pDC.pin_n) annotation(
      Line(points = {{-100, -40}, {-100, -24}, {-88, -24}, {-88, -9.8}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(wSensor.flange, flange_a) annotation(
      Line(points = {{84, 52}, {84, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(variableLimiter.y, torque.tau) annotation(
      Line(points = {{-49, 30}, {-60, 30}, {-60, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(torque.flange, powSensor.flange_a) annotation(
      Line(points = {{4, 60}, {18, 60}}, color = {0, 0, 0}));
    connect(powSensor.flange_b, inertia.flange_a) annotation(
      Line(points = {{38, 60}, {48, 60}}, color = {0, 0, 0}));
    connect(inertia.flange_b, flange_a) annotation(
      Line(points = {{68, 60}, {98, 60}}, color = {0, 0, 0}));
    connect(fromPuTorque1.u, limTau.yL) annotation(
      Line(points = {{21.2, 2}, {24, 2.8}, {29, 2.8}}, color = {0, 0, 127}));
    connect(fromPuTorque.u, limTau.yH) annotation(
      Line(points = {{21.2, 30}, {26, 30}, {26, 17.2}, {29, 17.2}}, color = {0, 0, 127}));
    connect(variableLimiter.limit1, fromPuTorque.y) annotation(
      Line(points = {{-26, 38}, {2, 38}, {2, 30}, {7.4, 30}}, color = {0, 0, 127}));
    connect(variableLimiter.limit2, fromPuTorque1.y) annotation(
      Line(points = {{-26, 22}, {-4, 22}, {-4, 2}, {7.4, 2}}, color = {0, 0, 127}));
    connect(limTau.w, toPuSpeed.y) annotation(
      Line(points = {{52, 10}, {59.2, 10}}, color = {0, 0, 127}));
    connect(toPuSpeed.u, wSensor.w) annotation(
      Line(points = {{77.6, 10}, {84, 10}, {84, 35.2}}, color = {0, 0, 127}));
    connect(pDC.Pref, toElePow.elePow) annotation(
      Line(points = {{-79.8, 0}, {-68, 0}, {-68, -24}, {-58.6, -24}}, color = {0, 0, 127}));
    connect(toElePow.tau, variableLimiter.y) annotation(
      Line(points = {{-36, -20}, {-28, -20}, {-28, 0}, {-60, 0}, {-60, 30}, {-49, 30}}, color = {0, 0, 127}));
    connect(toElePow.w, wSensor.w) annotation(
      Line(points = {{-36, -28}, {84, -28}, {84, 35.2}}, color = {0, 0, 127}));
    connect(pDC.Pref, toElePow1.elePow) annotation(
      Line(points = {{-79.8, 0}, {-68, 0}, {-68, -46}, {-58.6, -46}}, color = {0, 0, 127}));
    connect(toElePow1.tau, variableLimiter.y) annotation(
      Line(points = {{-36, -42}, {-28, -42}, {-28, 0}, {-60, 0}, {-60, 30}, {-49, 30}}, color = {0, 0, 127}));
    connect(toElePow1.w, wSensor.w) annotation(
      Line(points = {{-36, -50}, {84, -50}, {84, 35.2}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -60}, {100, 80}}, preserveAspectRatio = false), graphics = {Text(textColor = {238, 46, 47}, extent = {{12, -36}, {54, -40}}, textString = "efficiencyFromTable"), Text(textColor = {238, 46, 47}, extent = {{30, -30}, {72, -46}}, textString = "true

false")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics = {Line(points = {{62, -7}, {82, -7}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{52, 10}, {100, -10}}), Line(points = {{-98, 40}, {-70, 40}}, color = {0, 0, 255}), Line(points = {{-92, -40}, {-70, -40}}, color = {0, 0, 255}), Text(origin = {-17.6473, 11.476}, textColor = {0, 0, 255}, extent = {{-82.3527, 82.524}, {117.641, 50.524}}, textString = "%name"), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, 54}, {80, -54}}), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-74, 26}, {72, -26}}), Text(origin = {-5.9876, 35}, extent = {{-70.0124, -27}, {79.9876, -47}}, textString = "J=%J")}),
      Documentation(info = "<html><head></head><body><p>Partial model for one-flange components.</p>
<p>It contains the large majority of features: inherited components just add the input torque, either from a real input (OneFlange) or an expandable connector (OneFlangeConn).</p>
<p>It has several options:</p>
<p>- torque limits can be fixed values or be taken from a file, depending on <span style=\"font-family: Courier New;\">limitsOnFile</span> parameter. When limits are from a file, the latter can be written in SI units or with normalised torque and speed (will be multiplied by tauMax and wMax)</p>
<p>- efficiency can be defined through a loss formula or a matrix; the latter can, in turn be taken from a file or set online.</p><p><br></p><p>The model does not include the initial speed in the mask, since it is assumed it is set from the outside, e.g. from a connected intertia .</p>
</body></html>", revisions = "<html><head></head><body></body></html>"));
  end PartialOneFlange;

  partial model PartialTwoFlange "Simple map-based two-flange electric drive model"
    import Modelica.Constants.pi;
  
    //Alias variables:
    Modelica.Units.SI.Torque tauElectrical=inertia.tau;
    Modelica.Units.SI.AngularVelocity wMechanical=wSensor.w;
  
    parameter Modelica.Units.SI.Power powMax = 50000 "Maximum Mechanical drive power";
    parameter Modelica.Units.SI.Torque tauMax = 400 "Maximum drive Torque";
    parameter Modelica.Units.SI.AngularVelocity wMax = 650 "Maximum drive speed";
    parameter Modelica.Units.SI.MomentOfInertia J = 0.59 "Moment of Inertia";
    parameter Boolean mapsOnFile = false "= true, if efficiency table is taken from a txt file" 
                             annotation(Dialog(group = "Efficiency related parameters"),choices(checkBox = true));
    parameter Real eTorqueFactor=1 "factor applied to input torque for efficiencies when they are from file"
                         annotation(Dialog(group = "Efficiency related parameters", enable=mapsOnFile));
    parameter Real eSpeedFactor=60/(2*pi) "factor applied to input speed for efficiencies when they are from file"
                         annotation(Dialog(group = "Efficiency related parameters", enable=mapsOnFile));
    parameter String mapsFileName = "noName" "File where efficiency table is stored" annotation(
      Dialog(group = "Efficiency related parameters",enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String effTableName = "noName" "Name of the on-file maximum torque as a function of speed" annotation(
      Dialog(group = "Efficiency related parameters",enable = mapsOnFile));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] annotation(
      Dialog(group = "Efficiency related parameters",enable = not mapsOnFile));
    SupportModels.MapBasedRelated.LimTorqueFV limTau(tauMax = tauMax, wMax = wMax, powMax = powMax) annotation(
      Placement(transformation(extent = {{-58, -8}, {-36, 14}})));
    SupportModels.MapBasedRelated.InertiaTq inertia(w(displayUnit = "rad/s", start = 0), J = J) annotation(
      Placement(transformation(extent = {{8, 40}, {28, 60}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-80, 40})));
    SupportModels.MapBasedRelated.EfficiencyCT effMap(mapOnFile = mapsOnFile, mapFileName = mapsFileName, effTableName = effTableName, effTable = effTable) annotation(
      Placement(transformation(extent = {{20, -46}, {40, -26}})));
    SupportModels.MapBasedRelated.ConstPg constPDC annotation(
      Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = -90, origin = {0, 100})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outBPow_ annotation(
      Placement(transformation(extent = {{62, 40}, {82, 60}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outAPow_ annotation(
      Placement(transformation(extent = {{-18, 40}, {-38, 60}})));
    Modelica.Blocks.Math.Add add annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {32, 10})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation(
      Placement(visible = true, transformation(extent = {{90, 40}, {110, 60}}, rotation = 0), iconTransformation(extent = {{90, -12}, {110, 8}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation(
      Placement(visible = true, transformation(extent = {{-110, 40}, {-90, 60}}, rotation = 0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(visible = true, transformation(extent = {{-70, 90}, {-50, 110}}, rotation = 0), iconTransformation(extent = {{-50, 72}, {-30, 92}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.VariableLimiter torqueLimiter annotation(
      Placement(transformation(extent = {{-16, -8}, {4, 12}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(visible = true, transformation(extent = {{42, 90}, {62, 110}}, rotation = 0), iconTransformation(extent = {{30, 72}, {50, 92}}, rotation = 0)));
    final parameter Real eTorqueFactor_(fixed=false);
    final parameter Real eSpeedFactor_(fixed=false);
  initial equation
    if mapsOnFile then
      eTorqueFactor_ = eTorqueFactor;
      eSpeedFactor_  = eSpeedFactor;
    else
      eTorqueFactor_ = 1;
      eSpeedFactor_  = 1;
    end if;
  equation
    connect(flange_a, wSensor.flange) annotation(
      Line(points = {{-100, 50}, {-80, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(effMap.w, wSensor.w) annotation(
      Line(points = {{18, -40}, {-80, -40}, {-80, 29}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(pin_p, constPDC.pin_p) annotation(
      Line(points = {{-60, 100}, {-10, 100}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(effMap.elePow, constPDC.Pref) annotation(
      Line(points = {{40.6, -36}, {52, -36}, {52, 80}, {0, 80}, {0, 91.8}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(flange_b, outBPow_.flange_b) annotation(
      Line(points = {{100, 50}, {82, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, outBPow_.flange_a) annotation(
      Line(points = {{28, 50}, {62, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_a, outAPow_.flange_a) annotation(
      Line(points = {{8, 50}, {-18, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(outAPow_.flange_b, wSensor.flange) annotation(
      Line(points = {{-38, 50}, {-80, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(add.u1, outBPow_.power) annotation(
      Line(points = {{38, 22}, {38, 28}, {64, 28}, {64, 39}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(add.u2, outAPow_.power) annotation(
      Line(points = {{26, 22}, {26, 28}, {-20, 28}, {-20, 39}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(torqueLimiter.limit1, limTau.yH) annotation(
      Line(points = {{-18, 10}, {-28, 10}, {-28, 9.6}, {-34.9, 9.6}}, color = {0, 0, 127}));
    connect(torqueLimiter.limit2, limTau.yL) annotation(
      Line(points = {{-18, -6}, {-28, -6}, {-28, -3.6}, {-34.9, -3.6}}, color = {0, 0, 127}));
    connect(torqueLimiter.y, inertia.tau) annotation(
      Line(points = {{5, 2}, {12.55, 2}, {12.55, 40}}, color = {0, 0, 127}));
    connect(effMap.tau, torqueLimiter.y) annotation(
      Line(points = {{18, -32}, {12, -32}, {12, 2}, {5, 2}}, color = {0, 0, 127}));
    connect(limTau.w, wSensor.w) annotation(
      Line(points = {{-60.2, 3}, {-80, 3}, {-80, 29}}, color = {0, 0, 127}));
    connect(constPDC.pin_n, pin_n) annotation(
      Line(points = {{9.8, 100}, {18, 100}, {18, 100}, {52, 100}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 100}})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {4, -112}, textColor = {0, 0, 255}, extent = {{-110, 68}, {100, 36}}, textString = "%name"), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-64, 38}, {64, -42}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 10}, {-64, -10}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{64, 8}, {100, -12}}), Line(origin = {20, 0}, points = {{-60, 86}, {-60, 36}}, color = {0, 0, 255}), Line(origin = {-20, 0}, points = {{60, 80}, {60, 34}}, color = {0, 0, 255}), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-58, 14}, {58, -18}}), Text(origin = {-0.07637, 48.3161}, extent = {{-51.9236, -36.3161}, {48.0764, -66.3161}}, textString = "J=%J")}),
      Documentation(info = "<html>
<p>Partial model for final models TwoFlange and TwoFlangeConn</p>
</html>"));
  end PartialTwoFlange;

  partial model PartialIceBase "Partial map-based ice model"
    import Modelica.Constants.*;
    parameter Modelica.Units.SI.AngularVelocity wIceStart = 167 annotation(
      Dialog(group = "General parameters"));
    parameter Modelica.Units.SI.MomentOfInertia iceJ = 0.5 "ICE moment of Inertia" annotation(
      Dialog(group = "General parameters"));
    parameter Boolean scMapOnFile = false "= true, if tables are taken from a txt file" annotation(
      choices(checkBox = true),
      Dialog(group = "Consumption map related parameters"));
    parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
      Dialog(group = "General parameters", loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "NoName" "Name of the on-file specific consumption matrix" annotation(
      Dialog(enable = scMapOnFile, group = "Consumption map related parameters"));
    parameter Real scTorqueFactor = 1 "Torque multiplier for specific consumption  map " annotation(
      Dialog(enable = scMapOnFile, group = "Consumption map related parameters"));
    parameter Real scSpeedFactor = 60/(2*pi) "Speed multiplier for specific consumption  map (see info)" annotation(
      Dialog(enable = scMapOnFile, group = "Consumption map related parameters"));
    parameter Real scConsFactor = 1 "Output multiplier for specific consumption map" annotation(
      Dialog(enable = scMapOnFile, group = "Consumption map related parameters"));
    parameter Boolean tlMapOnFile = false "= true, if tables are taken from a txt file" annotation(
      choices(checkBox = true),
      Dialog(group = "Torque limit map related parameters"));
    parameter String torqueLimitName = "NoName" "Name of the on-file torque-limit matrix" annotation(
      Dialog(enable = tlMapOnFile, group = "Torque limit map related parameters"));
    parameter Real tlTorqueFactor = 1 "Torque multiplier for for torque limit map " annotation(
      Dialog(enable = tlMapOnFile, group = "Torque limit map related parameters"));
    parameter Real tlSpeedFactor = 60/(2*pi) "Speed multiplier for torque limit map" annotation(
      Dialog(enable = tlMapOnFile, group = "Torque limit map related parameters"));
    parameter Real maxIceTau[:, 2](each unit = "N.m") = [100, 80; 200, 85; 300, 92; 350, 98; 400, 98] "Maximum ICE generated torque" annotation(
      Dialog(enable = not tlMapOnFile, group = "Torque limit map related parameters"));
    /*
    parameter Real specificCons[:, :](each unit = "g/(kW.h)") = [0.0, 100, 200, 300, 400, 500; 10, 630, 580, 550, 580, 630; 20, 430, 420, 400, 400, 450; 30, 320, 325, 330, 340, 350; 40, 285, 285, 288, 290, 300; 50, 270, 265, 265, 270, 275; 60, 255, 248, 250, 255, 258; 70, 245, 237, 238, 243, 246; 80, 245, 230, 233, 237, 240; 90, 235, 230, 228, 233, 235] "ICE specific consumption map. First column torque, first row speed" annotation(
      Dialog(enable = not scMapOnFile, group = "Consumption map related parameters"));
  */
    parameter Real specificCons[:, :](each unit = "g/(kW.h)") = [0.0,100,300,500; 0,999,999,
      999; 100,400,400,400; 300,350,245,270; 400,400,270,270] "ICE specific consumption map. First column torque, first row speed" annotation(
      Dialog(enable = not scMapOnFile, group = "Consumption map related parameters"));
  
    Modelica.Units.SI.Torque tauGenerated = iceTau.tau;
    Modelica.Units.SI.Torque tauMechanical = -flange_a.tau;
    Modelica.Units.SI.AngularVelocity wMechanical = wSensor.w;
  
    Modelica.Mechanics.Rotational.Components.Inertia inertia(w(fixed = true, start = wIceStart, displayUnit = "rpm"), J = iceJ) annotation(
      Placement(visible = true, transformation(extent = {{30, 68}, {50, 88}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sources.Torque iceTau annotation(
      Placement(visible = true, transformation(extent = {{4, 68}, {24, 88}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor icePow annotation(
      Placement(transformation(extent = {{66, 88}, {86, 68}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation(
      Placement(visible = true, transformation(origin = {58, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Blocks.Math.Product toPowW annotation(
      Placement(visible = true, transformation(origin = {-18, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation(
      Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Blocks.Math.Gain tokW(k = 0.001) annotation(
      Placement(visible = true, transformation(origin = {-18, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Product toG_perHour annotation(
      Placement(visible = true, transformation(origin = {38, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Continuous.Integrator tokgFuel(k = 1/3.6e6) annotation(
      Placement(visible = true, transformation(origin = {38, -74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Logical.Switch switch1 annotation(
      Placement(visible = true, transformation(origin = {8, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
      Placement(visible = true, transformation(extent = {{-34, -82}, {-14, -62}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression rotorW(y = wSensor.w) annotation(
      Placement(transformation(origin={-94,4},     extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    SupportModels.MapBasedRelated.CombiTable1Factor limTauMap(
       uFactor = tlSpeedFactor, 
       yFactor = tlTorqueFactor, 
       tableOnFile = tlMapOnFile, 
       tableName = torqueLimitName, 
       fileName = mapsFileName, 
       table = maxIceTau)  annotation(
      Placement(transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}})));
    SupportModels.MapBasedRelated.CombiTable2Factor toGramsPerkWh(
       yFactor = scConsFactor, 
       u1Factor = scSpeedFactor, 
       u2Factor = scTorqueFactor, 
       tableOnFile = scMapOnFile, 
       tableName = specConsName, 
       fileName = mapsFileName, 
       table = specificCons)  annotation(
      Placement(transformation(origin = {44, 16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  equation
    connect(toPowW.y, tokW.u) annotation(
      Line(points = {{-18, 25}, {-18, 20}}, color = {0, 0, 127}));
    connect(toPowW.u2, iceTau.tau) annotation(
      Line(points = {{-24, 48}, {-24, 58}, {-6, 58}, {-6, 78}, {2, 78}}, color = {0, 0, 127}));
    connect(iceTau.flange, inertia.flange_a) annotation(
      Line(points = {{24, 78}, {30, 78}}));
    connect(wSensor.flange, inertia.flange_b) annotation(
      Line(points = {{58, 72}, {58, 78}, {50, 78}}));
    connect(icePow.flange_a, inertia.flange_b) annotation(
      Line(points = {{66, 78}, {50, 78}}));
    connect(toPowW.u1, wSensor.w) annotation(
      Line(points = {{-12, 48}, {-12, 51}, {58, 51}}, color = {0, 0, 127}));
    connect(icePow.flange_b, flange_a) annotation(
      Line(points = {{86, 78}, {94, 78}, {94, 0}, {100, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(toG_perHour.y, tokgFuel.u) annotation(
      Line(points = {{38, -51}, {38, -62}}, color = {0, 0, 127}));
    connect(zero.y, switch1.u3) annotation(
      Line(points = {{-13, -72}, {-10, -72}, {-10, -60}, {-4, -60}}, color = {0, 0, 127}));
    connect(toG_perHour.u2, switch1.y) annotation(
      Line(points = {{32, -28}, {32, -20}, {22, -20}, {22, -52}, {19, -52}}, color = {0, 0, 127}));
    connect(switch1.u1, tokW.y) annotation(
      Line(points = {{-4, -44}, {-18, -44}, {-18, -3}}, color = {0, 0, 127}));
    connect(rotorW.y, limTauMap.u) annotation(
      Line(points = {{-94, 15}, {-94, 79}, {-88, 79}}, color = {0, 0, 127}));
  connect(wSensor.w, toGramsPerkWh.u1) annotation(
      Line(points = {{58, 52}, {58, 40}, {50, 40}, {50, 28}}, color = {0, 0, 127}));
  connect(toGramsPerkWh.u2, toPowW.u2) annotation(
      Line(points = {{38, 28}, {38, 58}, {-24, 58}, {-24, 48}}, color = {0, 0, 127}));
  connect(toGramsPerkWh.y, toG_perHour.u1) annotation(
      Line(points = {{44, 5}, {44, -28}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html><head></head><body><p><span style=\"font-family: MS Shell Dlg 2;\">Basic partial ICE model. Models that inherit from this:</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- PartialIceTNm used when ICE must follow a Torque request in Nm</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- PartialIceT01 used when ICE must follow a Torque request in per unit of the maximum allowed</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">See their documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">------------------------------------------------------------------</span></p><p>When consumption is taken from a file, multipliers are useful to reuse a map for a different vehicle: scSpeedFactor and scTorqueFactor multiply the computed speed and torque before entering the table, &nbsp;scConsFactor multiplies the table output before further processing.</p><div>Consider for instance the following map:</div><p><span style=\"font-family: 'Courier New';\"># First row: (from column 2) speed (rpm)&nbsp;</span></p><div><span style=\"font-family: 'Courier New';\"><span style=\"font-family: 'Courier New';\">
  # First column (from row 2): torque (Nm)<br>
  # body: spec. consumption (g/kWh).<br>
  double iceSpecificCons(10 6)<br>
  0.   100  200  300  400  500<br>
  10   630  580  550  580  630<br>
  20   430  420  400  400  450<br>
  30   320  325  330  340  350<br>
  40   285  285  288  290  300<br>
  50   270  265  265  270  275<br>
  60   255  248  250  255  258<br>
  70   245  237  238  243  246<br>
  80   245  230  233  237  240<br>
  90   235  230  228  233  235<br>
  
  
  
  
  </span></span></div><div><p>If I want to use a map from a file with the same shape as this for a vehicle having max speed=1000 rpm, max torque=200 Nm, max consumption 500g/kWh, I will use:&nbsp;</p><p>scSpeedFactor=60/(2*pi)*500/1000,</p><p>scTorqueFactor=90/200,&nbsp;</p><p>scConsFactor=500/630.</p><p>Note that internally speeds are computed in rad/s; since here in the table here they are in rpm, I must include rad/s to rpm conversion.</p><p>If, instead, I want to use exactly this map, I will use:</p><p>scConsFactor=scTorqueFactor=1, scSpeedFactor=60/(2*pi)</p><p>These three factors are not used when data is not taken from a txt file.</p><p><br></p><p><b>Inherited models</b></p><p>Inherited models PartialIceTNm and PartilIceT01 can also use tables to input torque limits. These tables allow using the same torque and speed multipliers used for fuel consumption: torqueMultiplier and speedMultiplier.</p><div><br></div><p><br></p></div><div><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div>
  </body></html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 62}, {100, -100}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-24, 48}, {76, -44}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Text(extent = {{-42, -56}, {112, -80}}, textString = "J=%iceJ"), Text(origin = {0, 10}, textColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 14}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
              100,100}}),                                    graphics = {Line(points = {{-20, 78}, {-4, 78}}, color = {238, 46, 47})}));
  end PartialIceBase;

  partial model PartialIceTNm "Partial map-based ice model"
    import Modelica.Constants.*;
    extends PartialIceBase;
    parameter Modelica.Units.SI.AngularVelocity wIceStart = 167;
    parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "NoName" "name of the on-file specific consumption variable" annotation(
      Dialog(enable = mapsOnFile));
    Modelica.Blocks.Math.Min min1 annotation(
      Placement(transformation(origin = {2, 0}, extent = {{-34, 68}, {-14, 88}})));
  equation
    connect(min1.y, iceTau.tau) annotation(
      Line(points = {{-11, 78}, {2, 78}}, color = {0, 0, 127}));
  connect(min1.u1, limTauMap.y[1]) annotation(
      Line(points = {{-34, 84}, {-52, 84}, {-52, 80}, {-64, 80}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html><head></head><body><p><span style=\"font-family: MS Shell Dlg 2;\">Partial ICE model with torque input in Newton-metres. </span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">Models that inherit from this:</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- partialIceP that contains an in ternal loop so that the request from the exterior is now in power instead of torque</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- IceP used when ICE must follow a Power request </span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnP used when ICE must follow a Power request through an expandable connector</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnPOO used when ICE must follow a Power request through an expandable connector, and also ON/Off can be commanded from the outside</span></p>
  <p><span style=\"font-family: MS Shell Dlg 2;\">- IceT used when ICE must follow a Torque request </span></p>
  <p><span style=\"font-family: Arial;\">See their documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</span></p><p><span style=\"font-family: Arial;\">---</span></p><p><span style=\"font-family: Arial;\">To make access to torque limit table from file more flexible, the speed measured on the system is first multiplied by tlSpeedFactor; the obtained torque is then multiplied by tlTorqueFactor.&nbsp;</span></p><p><font face=\"Arial\">For instance speeds in the table might be in rpm instead of the SI rad/s. In this case, instead of manuallly multiplying all values in the input table, which might be tedious and error-prone, I can just set:</font></p><p><font face=\"Arial\">tlSpeedFactor=60/(2*pi)</font></p><p><font face=\"Arial\">Another example of usage of factors is when I want to re-use a torque limit map for a different machine, having the same shape but different values, If for instance I have a machine that has limits twice the one present in the table I can use:</font></p><p><font face=\"Arial\">tlTorqueFactor=2.</font></p><p><font face=\"Arial\">Inputted parameters tlTorqueFactor and tlSpeedFactor are not used when torque limit data are not taken from a txt file.</font></p><p><br></p>
  </body></html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(extent={{-120,-100},{100,100}},      preserveAspectRatio=false),   graphics = {Line(origin = {0, -12}, points = {{-50, 84}, {-36, 84}}, color = {255, 0, 0})}));
  end PartialIceTNm;

  partial model PartialIceT01 "Partial map-based ice model"
    import Modelica.Constants.*;
    extends PartialIceBase;
    parameter Modelica.Units.SI.MomentOfInertia iceJ = 0.5 "ICE moment of Inertia";
    // rad/s
    parameter String mapsFileName = "NoName" "File where specific consumption matrix is stored" annotation(
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "NoName" "name of the on-file specific consumption variable" annotation(
      Dialog(enable = mapsOnFile));
    Modelica.Blocks.Math.Product product annotation(
      Placement(transformation(origin = {-2, 0}, extent = {{-34, 68}, {-14, 88}})));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-60, -24})));
    Modelica.Blocks.Interfaces.RealInput nTauRef "normalized torque request" annotation(
      Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -98}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -120})));
  equation
    connect(product.u2, limiter.y) annotation(
      Line(points = {{-38, 72}, {-60, 72}, {-60, -13}}, color = {0, 0, 127}));
    connect(product.u1, limTauMap.y[1]) annotation(
      Line(points = {{-38, 84}, {-54, 84}, {-54, 80}, {-64, 80}}, color = {0, 0, 127}));
    connect(product.y, iceTau.tau) annotation(
      Line(points = {{-15, 78}, {2, 78}}, color = {0, 0, 127}));
    connect(limiter.u, nTauRef) annotation(
      Line(points = {{-60, -36}, {-60, -98}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial ICE model with torque input in per unit of the maximum torque. Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT01 used when ICE must follow a Torque request in per unit of the maximum torque.</span></p>
<p>See its documentation for further details or Appendix 3 in EHPTexamples tutorial for the general taxonomy of ICE based models.</p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(origin = {0, 10}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
              100,100}})));
  end PartialIceT01;

  partial model PartialIceP "Extends PartialIce0 adding power input"
    extends PartialIceTNm;
    parameter Real contrGain(unit = "N.m/W") = 0.1 "Proportional controller gain" annotation(
      Dialog(group = "General parameters"));
    Modelica.Blocks.Math.Feedback feedback annotation(
      Placement(transformation(origin={-14,-26},    extent = {{-98, 94}, {-78, 74}})));
    Modelica.Blocks.Math.Gain gain(k = contrGain) annotation(
      Placement(transformation(origin={6,-26},    extent = {{-70, 78}, {-58, 90}})));
  equation
    connect(gain.u, feedback.y) annotation(
      Line(points={{-65.2,58},{-93,58}},                          color = {0, 0, 127}));
    connect(feedback.u2, icePow.power) annotation(
      Line(points={{-102,66},{-102,98},{68,98},{68,89}},          color = {0, 0, 127}));
    connect(gain.y, min1.u2) annotation(
      Line(points={{-51.4,58},{-50,58},{-50,72},{-34,72}},        color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basic partial ICE model. Models that inherit from this:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceT used when ICE must follow a Torque request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceP used when ICE must follow a Power request </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- IceConnP used when ICE must follow a Power request trhough an expandable connector</span></p>
<p>Data for tables (here called &quot;maps&quot;) can be set manually or loaded from a file.</p>
<h4>Inherited models connect torque request to the free input of min() block.</h4>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 62}, {100, -100}}), Text(origin = {0, 10}, textColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}}), Text(textColor = {162, 29, 33}, extent = {{-90, -52}, {-36, -84}}, textString = "P", textStyle = {TextStyle.Bold, TextStyle.Italic})}),
      Diagram(coordinateSystem(extent={{-120,-100},{100,100}},      preserveAspectRatio=false),   graphics = {Text(extent = {{-98, -64}, {-54, -100}}, textString = "follows the power
reference 
and computes consumption"), Line(origin={-74,-26},    points={{-46,84},{-36,84}},      color = {255, 0, 0})}));
  end PartialIceP;

partial model PartialGenset "GenSet= GMS+ICE+GEN"
  import Modelica.Constants.inf;
  import Modelica.Constants.pi;
  // General parameters:
  parameter Real gsRatio = 1 "IdealGear speed reduction factor";
  parameter Real throttlePerWerr = 100/maxGenW "internal throttle controller proportional gain";
  parameter Real uDcNom=100"nominal DC voltage (only order of magnitude needs to be right";

// general tab ICE related parameters :
  parameter Modelica.Units.SI.MomentOfInertia jIce = 0.1 "ICE moment of inertia" annotation(
    Dialog(group = "ICE parameters"));
  parameter Modelica.Units.SI.AngularVelocity wIceStart = 167 annotation(
    Dialog(group = "ICE parameters"));
  // general tab generator related parameters:
  parameter Boolean mapsOnFile=true  annotation(choices(checkBox = true));
  parameter Real constFuelConsumption=200 "Fuel consumption in g/kWh when mapsOnfile=false"
       annotation(  Dialog(enable = not mapsOnFile,group = "ICE parameters"));
  parameter Modelica.Units.SI.AngularVelocity constOptimalSpeed=100
           "Optimal speed when mapsOnfile=false"
       annotation(  Dialog(enable = not mapsOnFile));
  // general tab generator related parameters:
  parameter Modelica.Units.SI.MomentOfInertia jGen = 0.1 "Generator moment of inertia" annotation(
    Dialog(group = "Generator parameters"));
   parameter Modelica.Units.SI.AngularVelocity maxGenW = 1e6 "Max generator angular speed when not mapsOnFile" annotation(
    Dialog(group = "Generator parameters", enable= not mapsOnFile));
  parameter Modelica.Units.SI.Power maxGenPow = 100e3 "Max mechanical power of the internal generator when not mapsOnFile" annotation(
    Dialog(group = "Generator parameters", enable= not mapsOnFile));
  parameter String mapsFileName = "maps.txt" "File containing data maps" annotation(
    Dialog(tab="Map related parameters"));
  parameter Modelica.Units.SI.Torque maxTau = 200 "Max torque between internal ICE and generator when not mapsOnFile" annotation(Dialog(group = "Generator parameters", enable= not mapsOnFile));
  parameter Real constGenEfficiency=0.85 "Gen efficiency when mapsOnfile=false"
        annotation(
    Dialog(enable = not mapsOnFile,group = "Generator parameters"));

// Parameters related to input maps (maps Tab):
    // GMS
  parameter String optiSpeedName = "optiSpeed"  "Name of the on-file specific consumption variable" annotation(
    Dialog(tab="Map related parameters", group="GMS parameters"));
  parameter Real osInFactor = 1 "Factor before inputting pRef into map from txt file" annotation(
    Dialog(tab="Map related parameters", group="GMS parameters", enable = mapsOnFile));
  parameter Real osOutFactor = 2*pi/60 "Factor after reading optiSpeed from txt file" annotation(
    Dialog(tab="Map related parameters", group="GMS parameters", enable = mapsOnFile));
  //ICE
  parameter String specConsName = "specificCons" "Name of the on-file specific consumption variable" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters"));
  parameter Real scTorqueFactor = 1 "Torque multiplier for specific consumption map" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters", enable = mapsOnFile));
  parameter Real scSpeedFactor = 2*pi/60 "Torque multiplier for specific consumption map" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters", enable = mapsOnFile));
  parameter Real scConsFactor = 1 "Output multiplier for specific consumption map" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters", enable = mapsOnFile));
  parameter String iceTauLimitName = "maxIceTau" "Name of the on-file max ICE torque matrix" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters"));
  parameter Real tlIceTorqueFactor = 1 "Torque multiplier for torque limit map" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters", enable = mapsOnFile));
  parameter Real tlIceSpeedFactor  = 1 "Speed multiplier for torque limit map" annotation(
    Dialog(tab="Map related parameters", group="ICE parameters", enable = mapsOnFile));
  //GEN
  parameter String efficiencyName = "gensetGenEff" "Name of the on-file generator efficiency matrix" annotation(
    Dialog(tab="Map related parameters", group="Gen parameters"));
  parameter Real eTorqueFactor=1 "Factor applied to input torque for efficiencies when they are from file"
        annotation( Dialog(tab="Map related parameters", group = "Gen parameters"));
  parameter Real eSpeedFactor=60/(2*pi) "Factor applied to input speed for efficiencies when they are from file"    annotation( Dialog(tab="Map related parameters", group = "Gen parameters", enable=mapsOnFile));
  parameter String genTauLimitName = "minMaxGenTau" "Name of the on-file max ICE torque matrix" annotation(
    Dialog(tab="Map related parameters", group="Gen parameters"));
  parameter Real tlGenTorqueFactor = 1 "Torque multiplier for torque limit map" annotation(
    Dialog(tab="Map related parameters", group="Gen parameters", enable = mapsOnFile));
  parameter Real tlGenSpeedFactor  = 1 "Speed multiplier for torque limit map" annotation(
    Dialog(tab="Map related parameters", group="Gen parameters", enable = mapsOnFile));

//actual Max speed value for consumption map (which in file is between 0 and 1)
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
      Placement(transformation(extent = {{-8, -8}, {8, 8}}, rotation = 180, origin = {-20, -40})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor icePow annotation(
      Placement(transformation(extent = {{28, -16}, {46, 2}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(extent = {{90, 50}, {110, 70}}), iconTransformation(extent = {{90, 50}, {110, 70}})));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMax = inf, uMin = 0) annotation(
      Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 90, origin = {-80, 48})));
    EHPTlib.MapBased.OneFlange gen(
      wMax = maxGenW,
      J = jGen,
      powMax = maxGenPow,
      tauMax = maxTau,
      uDcNom = uDcNom,
            
      effMapFileName = mapsFileName,
      effMapOnFile = mapsOnFile,
      effTable=constGenEfficiency*[0, 0, 1; 0, 1, 1; 1, 1, 1],
      effTableName = efficiencyName, 
      eTorqueFactor = eTorqueFactor, 
      eSpeedFactor = eSpeedFactor,

      limitsFileName = mapsFileName,
      limitsOnFile = mapsOnFile,
      tlTorqueFactor = tlGenTorqueFactor,
      tlSpeedFactor = tlGenSpeedFactor,
      tauLimitsMapName = genTauLimitName) annotation(
      Placement(visible = true, transformation(extent = {{74, 2}, {54, -18}}, rotation = 0)));
    IceT01 iceT(
      iceJ = jIce,
      scMapOnFile=mapsOnFile,
      tlMapOnFile=mapsOnFile,
      mapsFileName = mapsFileName,
      wIceStart = wIceStart,
      specConsName = specConsName,   
       specificCons=constFuelConsumption*[0, 100, 200; 100, 1, 1; 200, 1, 1],
      maxIceTau=maxTau*[0, 1.1; 100, 1.1],          
      torqueLimitName = iceTauLimitName,
      scTorqueFactor = scTorqueFactor, 
      scSpeedFactor = scSpeedFactor, 
      scConsFactor = scConsFactor, 
      tlTorqueFactor = tlIceTorqueFactor, 
      tlSpeedFactor = tlIceSpeedFactor)
     annotation(
      Placement(transformation(extent = {{-28, -18}, {-8, 4}})));
    Modelica.Blocks.Math.Gain gain(k = -gsRatio) annotation(
      Placement(transformation(extent = {{14, 24}, {34, 44}})));
    Modelica.Blocks.Math.Gain gain1(k = 1) annotation(
      Placement(visible = true, transformation(origin = {-80, -24}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
    Modelica.Blocks.Continuous.Integrator toFuelGrams(k = 1/3600) annotation(
      Placement(transformation(extent = {{24, -52}, {44, -32}})));
    Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio = gsRatio) annotation(
      Placement(visible = true, transformation(extent = {{4, -16}, {22, 2}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(extent = {{90, -46}, {110, -26}}), iconTransformation(extent = {{92, -70}, {112, -50}})));
    Modelica.Blocks.Interfaces.RealInput powRef(unit = "W") "Reference genset power" annotation(
      Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 90, origin = {60, 82}), iconTransformation(extent = {{15, -15}, {-15, 15}}, rotation = 90, origin = {57, 115})));
initial equation
  if not mapsOnFile then
     assert(wIceStart>0,"Initial rotational speed must be positive");
     /* RATIONALE OF THE FOLLOWING ASSERT
        We assume that optiSpeed<maxGenW
        If it is also wIceStart<maxGenW, the logic will impose null ICE torque and
        negative gen torque, to reach optiSpeed. But because we a re starting beyond
        maxgenW, gen torque will be zero. 
        SO, genset generated power will be constantly equal to zero, which is highly
        unrealistic. Moreover, given that the current ICE and Gen models do not have
        friction (at least to ICE they must be added soon) genset speed will stay 
        constantly equal to wIceStart, which is highly unrealistic as well. 
        it this condition 
       */
     assert(wIceStart<maxGenW,"initial rotational speed must be lower than the maximum allowable gen max speed, otherwise power will stay null all the time");
  end if;

  equation
    connect(gain.y, gen.tauRef) annotation(
      Line(points = {{35, 34}, {80, 34}, {80, -8}, {75.4, -8}}, color = {0, 0, 127}));
    connect(gen.pin_n, pin_p) annotation(
      Line(points = {{74, -4}, {84, -4}, {84, 60}, {100, 60}}, color = {0, 0, 255}));
    connect(icePow.flange_b, gen.flange_a) annotation(
      Line(points = {{46, -7}, {50, -7}, {50, -8}, {54, -8}}));
    connect(gain1.u, speedSensor.w) annotation(
      Line(points = {{-80, -31.2}, {-80, -40}, {-28.8, -40}}, color = {0, 0, 127}));
    connect(limiter.u, powRef) annotation(
      Line(points = {{-80, 60}, {-80, 68}, {60, 68}, {60, 82}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(speedSensor.flange, iceT.flange_a) annotation(
      Line(points = {{-12, -40}, {-2, -40}, {-2, -7}, {-8, -7}}, color = {0, 0, 0}));
    connect(toFuelGrams.u, iceT.fuelCons) annotation(
      Line(points = {{22, -42}, {12, -42}, {12, -26}, {-12, -26}, {-12, -19.1}}, color = {0, 0, 127}));
    connect(idealGear.flange_a, iceT.flange_a) annotation(
      Line(points = {{4, -7}, {-8, -7}}, color = {0, 0, 0}));
    connect(idealGear.flange_b, icePow.flange_a) annotation(
      Line(points = {{22, -7}, {28, -7}}, color = {0, 0, 0}));
    connect(gen.pin_p, pin_n) annotation(
      Line(points = {{74, -12}, {74, -36}, {100, -36}}, color = {0, 0, 255}));
    annotation(
      Evaluate = true,
      HideResult = true,
      choices(checkBox = true),
      Dialog(group = "Input map (ICE and Gen) parameters"),
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 80}})),
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-98, 94}, {82, 68}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, textString = "%name"), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-20, 0}, {26, -14}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-44, 30}, {-14, -44}}), Line(points = {{-72, 30}, {-72, 6}}), Polygon(points = {{-72, -2}, {-78, 8}, {-66, 8}, {-72, -2}}), Rectangle(extent = {{-96, 38}, {-50, -48}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-96, -6}, {-50, -24}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-78, -24}, {-68, -44}}), Polygon(points = {{-72, 34}, {-78, 24}, {-66, 24}, {-72, 34}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{6, 30}, {62, -44}}), Line(points = {{94, 60}, {74, 60}, {74, 18}, {62, 18}}, color = {0, 0, 255}), Line(points = {{100, -60}, {74, -60}, {74, -28}, {62, -28}}, color = {0, 0, 255})}),
      Documentation(info = "<html>
</html>"));
  end PartialGenset;
end Partial;
