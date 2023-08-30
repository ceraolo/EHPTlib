within EHPTlib.MapBased;
package Partial
  partial model PartialTwoFlange "Simple map-based two-flange electric drive model"
    parameter Modelica.Units.SI.Power powMax=50000
      "Maximum Mechanical drive power";
    parameter Modelica.Units.SI.Torque tauMax=400 "Maximum drive Torque";
    parameter Modelica.Units.SI.AngularVelocity wMax=650
      "Maximum drive speed";
    parameter Modelica.Units.SI.MomentOfInertia J=0.59 "Moment of Inertia";
    parameter Boolean mapsOnFile = false "= true, if tables are taken from a txt file";
    parameter String mapsFileName = "noName" "File where matrix is stored" annotation (
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String effTableName = "noName" "Name of the on-file maximum torque as a function of speed" annotation (
      Dialog(enable = mapsOnFile));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] annotation (
      Dialog(enable = not mapsOnFile));
    SupportModels.MapBasedRelated.LimTau limTau(tauMax = tauMax, wMax = wMax, powMax = powMax) annotation (
      Placement(transformation(extent = {{-58, -8}, {-36, 14}})));
    SupportModels.MapBasedRelated.InertiaTq inertia(w(displayUnit = "rad/s", start = 0), J = J) annotation (
      Placement(transformation(extent = {{8, 40}, {28, 60}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedRing annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-80, 40})));
    SupportModels.MapBasedRelated.EfficiencyT effMap(tauMax = tauMax, wMax = wMax, powMax = powMax, mapsOnFile = mapsOnFile, mapsFileName = mapsFileName, effTableName = effTableName, effTable = effTable) annotation (
      Placement(transformation(extent = {{20, -46}, {40, -26}})));
    SupportModels.MapBasedRelated.ConstPg constPDC annotation (
      Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = -90, origin = {0, 100})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outBPow_ annotation (
      Placement(transformation(extent = {{62, 40}, {82, 60}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor outAPow_ annotation (
      Placement(transformation(extent = {{-18, 40}, {-38, 60}})));
    Modelica.Blocks.Math.Add add annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {32, 10})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Right flange of shaft" annotation (
      Placement(visible = true, transformation(extent = {{90, 40}, {110, 60}}, rotation = 0), iconTransformation(extent = {{90, -12}, {110, 8}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation (
      Placement(visible = true, transformation(extent = {{-110, 40}, {-90, 60}}, rotation = 0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
      Placement(visible = true, transformation(extent = {{-70, 90}, {-50, 110}}, rotation = 0), iconTransformation(extent = {{-50, 88}, {-30, 108}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
      Placement(visible = true, transformation(extent = {{30, 90}, {50, 110}}, rotation = 0), iconTransformation(extent = {{30, 90}, {50, 110}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.VariableLimiter torqueLimiter annotation (
      Placement(transformation(extent = {{-16, -8}, {4, 12}})));
  equation
    connect(flange_a, speedRing.flange) annotation (
      Line(points = {{-100, 50}, {-80, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(effMap.w, speedRing.w) annotation (
      Line(points = {{18, -40}, {-80, -40}, {-80, 29}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(pin_p, constPDC.pin_p) annotation (
      Line(points = {{-60, 100}, {-10, 100}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(pin_n, constPDC.pin_n) annotation (
      Line(points = {{40, 100}, {9.8, 100}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(effMap.elePow, constPDC.Pref) annotation (
      Line(points = {{40.6, -36}, {52, -36}, {52, 80}, {0, 80}, {0, 91.8}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(flange_b, outBPow_.flange_b) annotation (
      Line(points = {{100, 50}, {82, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, outBPow_.flange_a) annotation (
      Line(points = {{28, 50}, {62, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_a, outAPow_.flange_a) annotation (
      Line(points = {{8, 50}, {-18, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(outAPow_.flange_b, speedRing.flange) annotation (
      Line(points = {{-38, 50}, {-80, 50}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(add.u1, outBPow_.power) annotation (
      Line(points = {{38, 22}, {38, 28}, {64, 28}, {64, 39}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(add.u2, outAPow_.power) annotation (
      Line(points = {{26, 22}, {26, 28}, {-20, 28}, {-20, 39}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(torqueLimiter.limit1, limTau.yH) annotation (
      Line(points = {{-18, 10}, {-28, 10}, {-28, 9.6}, {-34.9, 9.6}}, color = {0, 0, 127}));
    connect(torqueLimiter.limit2, limTau.yL) annotation (
      Line(points = {{-18, -6}, {-28, -6}, {-28, -3.6}, {-34.9, -3.6}}, color = {0, 0, 127}));
    connect(torqueLimiter.y, inertia.tau) annotation (
      Line(points = {{5, 2}, {12.55, 2}, {12.55, 40}}, color = {0, 0, 127}));
    connect(effMap.tau, torqueLimiter.y) annotation (
      Line(points = {{18, -32}, {12, -32}, {12, 2}, {5, 2}}, color = {0, 0, 127}));
    connect(limTau.w, speedRing.w) annotation (
      Line(points = {{-60.2, 3}, {-80, 3}, {-80, 29}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false,
      initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(origin = {-25, 2},
      extent = {{-75, 74}, {125, -74}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
              fillPattern = FillPattern.Solid), Text(origin = {4, -6}, lineColor = {0, 0, 255}, extent = {{-110, 84}, {100, 44}}, textString = "%name"), Rectangle(fillColor = {192, 192, 192},
              fillPattern = FillPattern.HorizontalCylinder, extent = {{-64, 38}, {64, -42}}), Rectangle(fillColor = {192, 192, 192},
              fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 10}, {-64, -10}}), Rectangle(fillColor = {192, 192, 192},
              fillPattern = FillPattern.HorizontalCylinder, extent = {{64, 8}, {100, -12}}), Line(origin = {20, 0}, points = {{-60, 94}, {-60, 76}}, color = {0, 0, 255}), Line(origin = {-20, 0}, points = {{60, 94}, {60, 76}}, color = {0, 0, 255}), Rectangle(fillColor = {255, 255, 255},
              fillPattern = FillPattern.Solid, extent = {{-58, 14}, {58, -18}}), Text(origin = {-0.07637, 48.3161}, extent = {{-51.9236, -36.3161}, {48.0764, -66.3161}}, textString = "J=%J")}),
      Documentation(info = "<html>
<p>This model receives from the connector the torque request (variable MotTauInt) and trieds to deliver it.</p>
<p>Howeve,r before delivering the requested torque, the model limits it considering the maximum deliverable torque and power. In addition it computes and considers inner losses as determined by means of a map. </p>
</html>"));
  end PartialTwoFlange;

  partial model PartialIce "Simple  map-based Internal Combustion Engine model"
    import Modelica.Constants.*;
    parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
    // rad/s
    parameter Modelica.Units.SI.MomentOfInertia iceJ=0.5
      "ICE moment of inertia";
    parameter Boolean tablesOnFile = false "= true, if tables are got from a file";
    parameter String mapsFileName = "NoName" "File where matrix is stored" annotation (
      Dialog(enable = tablesOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter Real maxIceTau[:, :] = [0, 80; 100, 80; 350, 95; 500, 95] "First column: speed (rad/s); first column: maximum ICE torque (Nm)" annotation (
      Dialog(enable = not tablesOnFile));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor w annotation (
      Placement(visible = true, transformation(origin = {52, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(visible = true, transformation(extent = {{90, 10}, {110, 30}}, rotation = 0), iconTransformation(extent = {{90, 10}, {110, 30}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor icePow annotation (
      Placement(visible = true, transformation(extent = {{66, 50}, {86, 70}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sources.Torque Tice annotation (
      Placement(visible = true, transformation(extent = {{-12, 50}, {8, 70}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(w(fixed = true, start = wIceStart, displayUnit = "rpm"), J = iceJ) annotation (
      Placement(visible = true, transformation(extent = {{16, 50}, {36, 70}}, rotation = 0)));
    Modelica.Blocks.Math.Product toPowW annotation (
      Placement(visible = true, transformation(origin = {0, 12}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Product toG_perHour annotation (
      Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    //  Modelica.Blocks.Continuous.Integrator toGrams(k = 1 / 3600000.0)
    // annotation(Placement(visible = true, transformation(origin = {26, -44},
    //extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Blocks.Tables.CombiTable1Dv toLimTau(table=maxIceTau)
      annotation (Placement(visible=true, transformation(
          origin={-72,66},
          extent={{10,-10},{-10,10}},
          rotation=180)));
    Modelica.Blocks.Sources.RealExpression rotorW(y = w.w) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-88, 36})));
    Modelica.Blocks.Math.Gain tokW(k = 1e-3) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {0, -18})));
    Modelica.Blocks.Tables.CombiTable2Ds toSpecCons(
      tableOnFile=true,
      fileName="PSDmaps.txt",
      tableName="specificCons") annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={40,0})));
  equation
    connect(toPowW.u1, w.w) annotation (
      Line(points = {{6, 24}, {6, 33}, {52, 33}}, color = {0, 0, 127}));
    connect(w.flange, inertia.flange_b) annotation (
      Line(points = {{52, 54}, {52, 60}, {36, 60}}));
    connect(icePow.flange_a, inertia.flange_b) annotation (
      Line(points = {{66, 60}, {36, 60}}));
    connect(Tice.flange, inertia.flange_a) annotation (
      Line(points = {{8, 60}, {16, 60}}));
    connect(icePow.flange_b, flange_a) annotation (
      Line(points = {{86, 60}, {94, 60}, {94, 20}, {100, 20}}));
    connect(toLimTau.u[1], rotorW.y) annotation (
      Line(points = {{-84, 66}, {-88, 66}, {-88, 47}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toPowW.y, tokW.u) annotation (
      Line(points = {{-2.22045e-015, 1}, {-2.22045e-015, -2}, {2.22045e-015, -2}, {2.22045e-015, -6}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toSpecCons.y, toG_perHour.u1) annotation (
      Line(points = {{40, -11}, {40, -24}, {36, -24}, {36, -38}}, color = {0, 0, 127}));
    connect(toG_perHour.u2, tokW.y) annotation (
      Line(points = {{24, -38}, {24, -32}, {0, -32}, {0, -29}}, color = {0, 0, 127}));
    connect(toSpecCons.u2, w.w) annotation (
      Line(points = {{46, 12}, {46, 28}, {52, 28}, {52, 33}}, color = {0, 0, 127}));
    connect(toSpecCons.u1, Tice.tau) annotation (
      Line(points = {{34, 12}, {34, 12}, {34, 38}, {34, 42}, {-22, 42}, {-22, 60}, {-14, 60}}, color = {0, 0, 127}));
    connect(toPowW.u2, Tice.tau) annotation (
      Line(points = {{-6, 24}, {-6, 42}, {-22, 42}, {-22, 60}, {-14, 60}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
      Documentation(info = "<html>
<h4>Basic map-based ICE model.</h4>
<p>It receives as input the reference torque as a fracton of the maximum deliverable torque at a given speed. It can be approximately thought as a signal proportional to the vehicle&apos;s accelerator pedal position.</p>
<p>The generated torque is the minimum between this signal and the maximum deliverable torque at the actual engine speed (defined by means of a table).</p>
<p>From the generated torque and speed the fuel consumption is computed.</p>
<p>The used maxTorque (toLimTau) and specific fuel consumption (toSpecCons) maps are inspired to public data related to the Toyota Prius&apos; engine </p>
</html>"),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(extent = {{-100, 80}, {100, -80}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
        fillPattern = FillPattern.Solid), Rectangle(fillColor = {192, 192, 192},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-24, 68}, {76, -24}}), Rectangle(fillColor = {192, 192, 192},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 30}, {100, 10}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 68}, {-32, -26}}), Rectangle(fillColor = {95, 95, 95},
        fillPattern = FillPattern.Solid, extent = {{-90, 22}, {-32, 0}}), Line(points = {{-60, 56}, {-60, 32}}), Polygon(points = {{-60, 66}, {-66, 56}, {-54, 56}, {-60, 66}}), Polygon(points = {{-60, 24}, {-66, 34}, {-54, 34}, {-60, 24}}), Rectangle(fillColor = {135, 135, 135},
        fillPattern = FillPattern.Solid, extent = {{-64, 0}, {-54, -20}})}));
  end PartialIce;

  model PartialIceP "Simple map-based ice model with connector and Power request"
    import Modelica.Constants.*;
    parameter Real contrGain = 0.1 "Proportional controller gain (Nm/W)";
    parameter Real wIceStart = 167;
    parameter Real iceJ = 0.5 "ICE moment of Inertia (kg.m^2)";
    // rad/s
    Modelica.Mechanics.Rotational.Components.Inertia inertia(w(fixed = true, start = wIceStart, displayUnit = "rpm"), J = iceJ) annotation (
      Placement(visible = true, transformation(extent = {{30, 42}, {50, 62}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sources.Torque iceTau annotation (
      Placement(visible = true, transformation(extent = {{4, 42}, {24, 62}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor Pice annotation (
      Placement(transformation(extent = {{66, 62}, {86, 42}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor w annotation (
      Placement(visible = true, transformation(origin = {58, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Blocks.Math.Product toPowW annotation (
      Placement(visible = true, transformation(origin = {-18, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(transformation(extent = {{-90, 62}, {-70, 42}})));
    Modelica.Blocks.Math.Gain gain(k = contrGain) annotation (
      Placement(visible = true, transformation(extent = {{-62, 42}, {-42, 62}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Blocks.Tables.CombiTable2Ds toGramsPerkWh(
      fileName="PSDmaps.txt",
      tableName="iceSpecificCons",
      tableOnFile=true) annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={42,-2})));
    Modelica.Blocks.Math.Gain tokW(k = 0.001) annotation (
      Placement(visible = true, transformation(origin = {-18, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e99, uMin = 0) annotation (
      Placement(visible = true, transformation(origin = {-22, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(toPowW.y, tokW.u) annotation (
      Line(points = {{-18, -1}, {-18, -6}}, color = {0, 0, 127}));
    connect(toPowW.u2, iceTau.tau) annotation (
      Line(points = {{-24, 22}, {-24, 32}, {-6, 32}, {-6, 52}, {2, 52}}, color = {0, 0, 127}));
    connect(iceTau.tau, limiter1.y) annotation (
      Line(points = {{2, 52}, {-10, 52}, {-10, 52}, {-11, 52}}, color = {0, 0, 127}));
    connect(limiter1.u, gain.y) annotation (
      Line(points = {{-34, 52}, {-42, 52}, {-42, 52}, {-41, 52}}, color = {0, 0, 127}));
    connect(toGramsPerkWh.u1, iceTau.tau) annotation (
      Line(points = {{36, 10}, {36, 32}, {-6, 32}, {-6, 52}, {2, 52}}, color = {0, 0, 127}));
    connect(iceTau.flange, inertia.flange_a) annotation (
      Line(points = {{24, 52}, {30, 52}}));
    connect(w.flange, inertia.flange_b) annotation (
      Line(points = {{58, 46}, {58, 52}, {50, 52}}));
    connect(Pice.flange_a, inertia.flange_b) annotation (
      Line(points = {{66, 52}, {50, 52}}));
    connect(toGramsPerkWh.u2, w.w) annotation (
      Line(points = {{48, 10}, {48, 20}, {58, 20}, {58, 25}}, color = {0, 0, 127}));
    connect(toPowW.u1, w.w) annotation (
      Line(points = {{-12, 22}, {-12, 25}, {58, 25}}, color = {0, 0, 127}));
    connect(gain.u, feedback.y) annotation (
      Line(points = {{-64, 52}, {-71, 52}}, color = {0, 0, 127}));
    connect(Pice.flange_b, flange_a) annotation (
      Line(points = {{86, 52}, {94, 52}, {94, 0}, {100, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(feedback.u2, Pice.power) annotation (
      Line(points = {{-80, 60}, {-80, 72}, {68, 72}, {68, 63}}, color = {0, 0, 127}, smooth = Smooth.None));
    annotation (
      Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</b> </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is a &QUOT;connector&QUOT; version of MBice.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For a general descritiption see the info of MBice.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Signals connected to the connector:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowRef (input) is the power request (W). Negative values are internally converted to zero</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- iceW (output) is the measured ICE speed (rad/s)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowDel (output) delivered power (W)</span></p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Rectangle(fillColor = {192, 192, 192},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-24, 48}, {76, -44}}), Rectangle(fillColor = {192, 192, 192},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Text(origin = {-2, 0}, extent = {{-140, -52}, {140, -86}}, textString = "J=%J"), Rectangle(extent = {{-100, 62}, {100, -100}}), Text(origin = {0, 10}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95},
        fillPattern = FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135},
        fillPattern = FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}),
      Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(extent = {{-90, 20}, {-46, -16}}, textString = "follows the power
reference \nand computes consumption")}));
  end PartialIceP;

  partial model PartialOneFlange "Partial map-based one-Flange electric drive model"
    parameter Modelica.Units.SI.Power powMax=22000
      "Maximum mechnical power";
    parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque";
    parameter Modelica.Units.SI.Voltage uDcNom=100 "nominal DC voltage";
    parameter Modelica.Units.SI.AngularVelocity wMax= 3000 "Maximum drive speed";
    parameter Modelica.Units.SI.MomentOfInertia J=0.25
      "Rotor's moment of inertia";
    parameter Boolean mapsOnFile = false "= true, if tables are taken from a txt file";
    parameter String mapsFileName = "noName" "File where matrix is stored" annotation (
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation (
      Dialog(enable = mapsOnFile));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both p.u. of max" annotation (
      Dialog(enable = not mapsOnFile));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation (
      Placement(transformation(extent = {{88, 50}, {108, 70}}, rotation = 0), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation (
      Placement(transformation(extent = {{8, -8}, {-8, 8}}, rotation = 90, origin = {78, 44})));
    SupportModels.MapBasedRelated.LimTau limTau(tauMax = tauMax, wMax = wMax, powMax = powMax) annotation (
      Placement(transformation(extent = {{40, 18}, {20, 42}})));
    SupportModels.MapBasedRelated.EfficiencyT toElePow(mapsOnFile = mapsOnFile, tauMax = tauMax, powMax = powMax, wMax = wMax, mapsFileName = mapsFileName, effTableName = effTableName, effTable = effTable) annotation (
      Placement(transformation(extent = {{-6, -28}, {-26, -8}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
      Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(extent = {{-110, 30}, {-90, 50}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
      Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(extent = {{-110, -50}, {-90, -30}})));
    SupportModels.MapBasedRelated.ConstPg constPDC(vNom = uDcNom) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-100, 0})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation (
      Placement(transformation(extent = {{22, 50}, {42, 70}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation (
      Placement(transformation(extent = {{-16, 50}, {4, 70}})));
    Modelica.Blocks.Math.Gain gain(k = 1) annotation (
      Placement(transformation(extent = {{-64, -10}, {-84, 10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powSensor annotation (
      Placement(transformation(extent = {{50, 50}, {70, 70}})));
    Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (
      Placement(transformation(extent = {{-4, 20}, {-24, 40}})));
  equation
  //  assert(wMax >= powMax / tauMax, "\n****  " + "wMax=" + String(wMax)+
  //       ";  powMax=" + String(powMax)+";  tauMax="+String(tauMax)+"  ***\n");
    connect(toElePow.w, wSensor.w) annotation (
      Line(points = {{-4, -22}, {78, -22}, {78, 35.2}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(pin_p, constPDC.pin_p) annotation (
      Line(points = {{-100, 40}, {-100, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(pin_n, constPDC.pin_n) annotation (
      Line(points = {{-100, -40}, {-100, -9.8}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(constPDC.Pref, gain.y) annotation (
      Line(points = {{-91.8, 0}, {-85, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(powSensor.flange_b, flange_a) annotation (
      Line(points = {{70, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(wSensor.flange, flange_a) annotation (
      Line(points = {{78, 52}, {78, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(toElePow.elePow, gain.u) annotation (
      Line(points = {{-26.6, -18}, {-46, -18}, {-46, 0}, {-62, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(inertia.flange_a, torque.flange) annotation (
      Line(points = {{22, 60}, {4, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, powSensor.flange_a) annotation (
      Line(points = {{42, 60}, {50, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(variableLimiter.limit1, limTau.yH) annotation (
      Line(points = {{-2, 38}, {19, 38}, {19, 37.2}}, color = {0, 0, 127}));
    connect(variableLimiter.limit2, limTau.yL) annotation (
      Line(points = {{-2, 22}, {10, 22}, {10, 22.8}, {19, 22.8}}, color = {0, 0, 127}));
    connect(variableLimiter.y, torque.tau) annotation (
      Line(points = {{-25, 30}, {-36, 30}, {-36, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(toElePow.tau, torque.tau) annotation (
      Line(points = {{-4, -14}, {2, -14}, {2, 12}, {-36, 12}, {-36, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(limTau.w, wSensor.w) annotation (
      Line(points = {{42, 30}, {78, 30}, {78, 35.2}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle( fillColor = {255, 255, 255},
              fillPattern =                                                                                                                                                                                                        FillPattern.Solid,extent={{-100,80},
                {100,-80}}),                                                                                                                                                                                                        Line(points = {{62, -7}, {82, -7}}), Rectangle(fillColor = {192, 192, 192},
              fillPattern =                                                                                                                                                                                                        FillPattern.HorizontalCylinder, extent = {{52, 10}, {100, -10}}), Line(points = {{-98, 40}, {-70, 40}}, color = {0, 0, 255}), Line(points = {{-92, -40}, {-70, -40}}, color = {0, 0, 255}), Text(origin={-17.6473,
                34.3183},                                                                                                                                                                                                        textColor = {0, 0, 255}, extent={{
                -82.3527,87.6817},{117.641,53.6817}},                                                                                                                                                                                                        textString = "%name"), Rectangle(fillColor = {192, 192, 192},
              fillPattern =                                                                                                                                                                                                        FillPattern.HorizontalCylinder, extent={{-74,54},
                {80,-54}}),                                                                                                                                                                                                        Rectangle(fillColor = {255, 255, 255},
              fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{-64,14},
                {70,-16}}),                                                                                                                                                                                                        Text(origin={-1.5886,
                32.3},                                                                                                                                                                                                      extent={{
                -64.4114,-24.3},{73.5886,-42.3}},                                                                                                                                                                                                    textString = "J=%J")}),
      Documentation(info = "<html>
<p>One-flange electric drive.</p>
<p>The input signal is the requested normalised torque (1 means nominal torque)</p>
</html>"));
  end PartialOneFlange;

  partial model PartialOneFlange2 "Partial map-based one-Flange electric drive model"
    parameter Modelica.Units.SI.Voltage uDcNom=100 "nominal DC voltage";
    parameter Modelica.Units.SI.MomentOfInertia J=0.25
      "Rotor's moment of inertia";
    parameter Boolean effMapOnFile = false "= true, if tables are taken from a txt file";
    parameter String mapsFileName = "noName" "File where efficiency/limits matrix/ces is/are stored" annotation (
      Dialog(enable = effMapOnFile or limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String effTableName = "noName" "Name of the on-file efficiency matrix" annotation (
      Dialog(enable = effMapOnFile));
    parameter Real effTable[:, :] = [0, 0, 1; 0, 1, 1; 1, 1, 1] "rows: speeds; columns: torques; both p.u. of max" annotation (
      Dialog(enable = not effMapOnFile));
    parameter Boolean limitsOnFile = false "= true, if torque limits are taken from a txt file";
    parameter Modelica.Units.SI.Power powMax=22000
      "Maximum mechnical power" annotation (Dialog(enable=not limitsOnFile));
    parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque"
      annotation (Dialog(enable=not limitsOnFile));
    parameter Modelica.Units.SI.AngularVelocity wMax=
      3000 "Maximum drive speed"
      annotation (Dialog(enable=not limitsOnFile));
    parameter String maxTorqueTableName = "noName" "Name of the on-file upper torque limit" annotation (
      Dialog(enable = limitsOnFile));
    parameter String minTorqueTableName = "noName" "Name of the on-file lower torque limit" annotation (
      Dialog(enable = limitsOnFile));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation (
      Placement(transformation(extent = {{88, 50}, {108, 70}}, rotation = 0), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation (
      Placement(transformation(extent = {{8, -8}, {-8, 8}}, rotation = 90, origin = {78, 44})));
    SupportModels.MapBasedRelated.LimTorque limTau(limitsOnFile = limitsOnFile, tauMax = tauMax, wMax = wMax, powMax = powMax, limitsFileName = mapsFileName, maxTorqueTableName = maxTorqueTableName, minTorqueTableName = minTorqueTableName) annotation (
      Placement(transformation(extent = {{40, 18}, {20, 42}})));
    SupportModels.MapBasedRelated.EfficiencyT toElePow(mapsOnFile = effMapOnFile, tauMax = tauMax, powMax = powMax, wMax = wMax, mapsFileName = mapsFileName, effTableName = effTableName, effTable = effTable) annotation (
      Placement(transformation(extent = {{-6, -28}, {-26, -8}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
      Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(extent = {{-110, 30}, {-90, 50}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
      Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(extent = {{-110, -50}, {-90, -30}})));
    SupportModels.MapBasedRelated.ConstPg constPDC(vNom = uDcNom) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-100, 0})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation (
      Placement(transformation(extent = {{22, 50}, {42, 70}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation (
      Placement(transformation(extent = {{-16, 50}, {4, 70}})));
    Modelica.Blocks.Math.Gain gain(k = 1) annotation (
      Placement(transformation(extent = {{-64, -10}, {-84, 10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powSensor annotation (
      Placement(transformation(extent = {{50, 50}, {70, 70}})));
    Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (
      Placement(transformation(extent = {{-4, 20}, {-24, 40}})));
  equation
  //  assert(wMax >= powMax / tauMax, "\n****\n" + "PARAMETER VERIFICATION ERROR:\nwMax must be not lower than powMax/tauMax" + "\n***\n");
    connect(toElePow.w, wSensor.w) annotation (
      Line(points = {{-4, -22}, {78, -22}, {78, 35.2}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(pin_p, constPDC.pin_p) annotation (
      Line(points = {{-100, 40}, {-100, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(pin_n, constPDC.pin_n) annotation (
      Line(points = {{-100, -40}, {-100, -9.8}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(constPDC.Pref, gain.y) annotation (
      Line(points = {{-91.8, 0}, {-85, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(powSensor.flange_b, flange_a) annotation (
      Line(points = {{70, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(wSensor.flange, flange_a) annotation (
      Line(points = {{78, 52}, {78, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(toElePow.elePow, gain.u) annotation (
      Line(points = {{-26.6, -18}, {-46, -18}, {-46, 0}, {-62, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(inertia.flange_a, torque.flange) annotation (
      Line(points = {{22, 60}, {4, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, powSensor.flange_a) annotation (
      Line(points = {{42, 60}, {50, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(variableLimiter.limit1, limTau.yH) annotation (
      Line(points = {{-2, 38}, {19, 38}, {19, 37.2}}, color = {0, 0, 127}));
    connect(variableLimiter.limit2, limTau.yL) annotation (
      Line(points = {{-2, 22}, {10, 22}, {10, 22.8}, {19, 22.8}}, color = {0, 0, 127}));
    connect(variableLimiter.y, torque.tau) annotation (
      Line(points = {{-25, 30}, {-36, 30}, {-36, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(toElePow.tau, torque.tau) annotation (
      Line(points = {{-4, -14}, {2, -14}, {2, 12}, {-36, 12}, {-36, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(limTau.w, wSensor.w) annotation (
      Line(points = {{42, 30}, {78, 30}, {78, 35.2}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(extent={{-100,-60},{100,80}},  preserveAspectRatio=false)),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false,
      initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(extent={{-100,80},
                {100,-80}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
              fillPattern =    FillPattern.Solid), Line(points = {{62, -7}, {82, -7}}),
               Rectangle(fillColor = {192, 192, 192},
              fillPattern =  FillPattern.HorizontalCylinder, extent = {{52, 10}, {100, -10}}),
               Text(origin={-17.6442,
                32.3174}, lineColor = {0, 0, 255}, extent={{
                -82.3558,87.6826},{117.644,53.6826}}, textString = "%name",
              fillPattern =  FillPattern.Solid, fillColor = {255, 255, 255}), Line(points={{-96,40},
                {-68,40}},  color = {0, 0, 255}), Line(points={{-90,-40},
                {-68,-40}}, color = {0, 0, 255}), Rectangle(fillColor = {192, 192, 192},
              fillPattern =  FillPattern.HorizontalCylinder, extent={{-80,56},{
                86,-48}}), Rectangle(fillColor = {255, 255, 255},
              fillPattern =  FillPattern.Solid, extent={{-70,18},{76,-14}}),
                             Text(origin={-1.1871,41.7},
                        extent={{-72.8129,-29.7},{83.1871,-51.7}},
                        textString = "J=%J")}),
      Documentation(info="<html>
<p>Partial one-flange electric drive.</p>
<p>The input signal is the requested normalised torque (1 means nominal torque)</p>
</html>"));
  end PartialOneFlange2;

  partial model PartialOneFlange2LF
    "Partial map-based one-Flange electric drive model"
    parameter Real A = 0.006 "fixed losses";
    parameter Real bT = 0.05 "torque losses coefficient";
    parameter Real bW = 0.02 "speed losses coefficient";
    parameter Real bP = 0.05 "power losses coefficient";

    parameter Modelica.Units.SI.Voltage uDcNom=100 "nominal DC voltage";
    parameter Modelica.Units.SI.MomentOfInertia J=0.25
      "Rotor's moment of inertia";
    parameter String limitsFileName = "noName" "File where limit matrices are stored" annotation (
      Dialog(enable = effMapOnFile or limitsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter Boolean limitsOnFile = false "= true, if torque limits are taken from a txt file";
    parameter Modelica.Units.SI.Power powMax=22000
      "Maximum mechnical power" annotation (Dialog(enable=not limitsOnFile));
    parameter Modelica.Units.SI.Torque tauMax=80 "Maximum torque"
      annotation (Dialog(enable=not limitsOnFile));
    parameter Modelica.Units.SI.AngularVelocity wMax=
      3000 "Maximum drive speed"
      annotation (Dialog(enable=not limitsOnFile));
    parameter String maxTorqueTableName = "noName" "Name of the on-file upper torque limit" annotation (
      Dialog(enable = limitsOnFile));
    parameter String minTorqueTableName = "noName" "Name of the on-file lower torque limit" annotation (
      Dialog(enable = limitsOnFile));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "Left flange of shaft" annotation (
      Placement(transformation(extent = {{88, 50}, {108, 70}}, rotation = 0), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor wSensor annotation (
      Placement(transformation(extent = {{8, -8}, {-8, 8}}, rotation = 90, origin = {78, 44})));
    SupportModels.MapBasedRelated.LimTorque limTau(
      limitsOnFile = limitsOnFile, tauMax = tauMax, wMax = wMax,
       powMax = powMax, limitsFileName = limitsFileName,
       maxTorqueTableName = maxTorqueTableName,
       minTorqueTableName = minTorqueTableName) annotation (
      Placement(transformation(extent = {{40, 18}, {20, 42}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
      Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(extent = {{-110, 30}, {-90, 50}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
      Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(extent = {{-110, -50}, {-90, -30}})));
    SupportModels.MapBasedRelated.ConstPg constPDC(vNom = uDcNom) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-100, 0})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation (
      Placement(transformation(extent = {{22, 50}, {42, 70}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation (
      Placement(transformation(extent = {{-16, 50}, {4, 70}})));
    Modelica.Blocks.Math.Gain gain(k = 1) annotation (
      Placement(transformation(extent = {{-64, -10}, {-84, 10}})));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor powSensor annotation (
      Placement(transformation(extent = {{50, 50}, {70, 70}})));
    Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (
      Placement(transformation(extent = {{-4, 20}, {-24, 40}})));
    SupportModels.MapBasedRelated.EfficiencyLF toElePow(
      A=A,
      bT=bT,
      bW=bW,
      bP=bP,
      tauMax=tauMax,
      powMax=powMax,
      wMax=wMax)
      annotation (Placement(transformation(extent={{-20,-36},{-40,-16}})));
  equation
  //  assert(wMax >= powMax / tauMax, "\n****\n" + "PARAMETER VERIFICATION ERROR:\nwMax must be not lower than powMax/tauMax" + "\n***\n");
    connect(pin_p, constPDC.pin_p) annotation (
      Line(points = {{-100, 40}, {-100, 10}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(pin_n, constPDC.pin_n) annotation (
      Line(points = {{-100, -40}, {-100, -9.8}}, color = {0, 0, 255}, smooth = Smooth.None));
    connect(constPDC.Pref, gain.y) annotation (
      Line(points = {{-91.8, 0}, {-85, 0}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(powSensor.flange_b, flange_a) annotation (
      Line(points = {{70, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(wSensor.flange, flange_a) annotation (
      Line(points = {{78, 52}, {78, 60}, {98, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_a, torque.flange) annotation (
      Line(points = {{22, 60}, {4, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(inertia.flange_b, powSensor.flange_a) annotation (
      Line(points = {{42, 60}, {50, 60}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(variableLimiter.limit1, limTau.yH) annotation (
      Line(points = {{-2, 38}, {19, 38}, {19, 37.2}}, color = {0, 0, 127}));
    connect(variableLimiter.limit2, limTau.yL) annotation (
      Line(points = {{-2, 22}, {10, 22}, {10, 22.8}, {19, 22.8}}, color = {0, 0, 127}));
    connect(variableLimiter.y, torque.tau) annotation (
      Line(points = {{-25, 30}, {-36, 30}, {-36, 60}, {-18, 60}}, color = {0, 0, 127}));
    connect(limTau.w, wSensor.w) annotation (
      Line(points = {{42, 30}, {78, 30}, {78, 35.2}}, color = {0, 0, 127}));
    connect(gain.u, toElePow.elePow) annotation (Line(points={{-62,0},{-52,
            0},{-52,-26},{-40.6,-26}}, color={0,0,127}));
    connect(toElePow.w, wSensor.w) annotation (Line(points={{-18,-30},{78,
            -30},{78,35.2}}, color={0,0,127}));
    connect(toElePow.tau, torque.tau) annotation (Line(points={{-18,-22},{
            -2,-22},{-2,10},{-36,10},{-36,60},{-18,60}}, color={0,0,127}));
    annotation (
      Diagram(coordinateSystem(extent={{-100,-60},{100,80}},  preserveAspectRatio = false,
        initialScale = 0.1, grid = {2, 2})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false,
        initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(extent={{-100,82},
                {100,-80}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
              fillPattern =  FillPattern.Solid), Line(points = {{62, -7}, {82, -7}}),
               Rectangle(fillColor = {192, 192, 192},
              fillPattern =  FillPattern.HorizontalCylinder, extent = {{52, 10}, {100, -10}}),
               Text(origin={-17.6441,
                34.313},  lineColor = {0, 0, 255}, extent={{
                -82.3559,87.6867},{117.644,53.687}}, textString = "%name",
              fillPattern =  FillPattern.Solid, fillColor = {255, 255, 255}),
                Line(points={{-102,42},
                {-74,42}},  color = {0, 0, 255}), Line(points={{-96,-38},
                {-74,-38}}, color = {0, 0, 255}),Rectangle(fillColor = {192, 192, 192},
              fillPattern =  FillPattern.HorizontalCylinder, extent={{-82,50},{
                82,-50}}), Rectangle(fillColor = {255, 255, 255},
              fillPattern =  FillPattern.Solid, extent={{-76,32},{74,-30}}),
                             Text(origin={-5.05401,59.7},
                             extent={{-70.9459,-29.7},{81.054,-51.7}},
                                                 textString = "J=%J"),
                    Text(origin={-4.25605,27.7},
                       extent={{-59.7439,-29.7},{68.2562,-51.7}},
            textString="LF",
            textColor={238,46,47},
            textStyle={TextStyle.Italic})}),
      Documentation(info="<html>
<p>Partial one-flange electric drive, with efficiency computed through a Loss Formula (LF)</p>
<p>The input signal is the requested normalised torque (1 means nominal torque)</p>
</html>"));
  end PartialOneFlange2LF;

  partial model PartialMBice "Simple  map-based Internal Combustion Engine model"
    import Modelica.Constants.*;
    parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
    parameter Modelica.Units.SI.MomentOfInertia iceJ=0.5
      "ICE moment of inertia";
    parameter Boolean mapsOnFile = false "= true, if tables are taken from a txt file";
    parameter String mapsFileName = "NoName" "File where matrix is stored" annotation (
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String maxTauName = "noName" "name of the on-file maximum torque as a function of speed" annotation (
      Dialog(enable = mapsOnFile));
    parameter String specConsName = "noName" "name of the on-file specific consumption variable" annotation (
      Dialog(enable = mapsOnFile));
    parameter Real maxIceTau[:, :] = [0, 80; 100, 80; 350, 95; 500, 95] "First column speed, second column maximum ice torque" annotation (
      Dialog(enable = not mapsOnFile));
    parameter Real specificConsTab[:, :](unit = "g/(kW.h)") = [0., 100, 200, 300, 400, 500; 10, 630, 580, 550, 580, 630; 20, 430, 420, 400, 400, 450; 30, 320, 325, 330, 340, 350; 40, 285, 285, 288, 290, 300; 50, 270, 265, 265, 270, 275; 60, 255, 248, 250, 255, 258; 70, 245, 237, 238, 243, 246; 80, 245, 230, 233, 237, 240; 90, 235, 230, 228, 233, 235] "ICE specific consumption map. First column torque, first row speed" annotation (
      Dialog(enable = not mapsOnFile));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor w annotation (
      Placement(visible = true, transformation(origin = {52, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(visible = true, transformation(extent = {{90, 10}, {110, 30}}, rotation = 0), iconTransformation(extent = {{90, 10}, {110, 30}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor icePow annotation (
      Placement(visible = true, transformation(extent = {{66, 50}, {86, 70}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sources.Torque Tice annotation (
      Placement(visible = true, transformation(extent = {{-12, 50}, {8, 70}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(w(fixed = true, start = wIceStart, displayUnit = "rpm"), J = iceJ) annotation (
      Placement(visible = true, transformation(extent = {{16, 50}, {36, 70}}, rotation = 0)));
    Modelica.Blocks.Math.Product toPow0 annotation (
      Placement(visible = true, transformation(origin = {0, 12}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Product toG_perHour annotation (
      Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    //  Modelica.Blocks.Continuous.Integrator toGrams(k = 1 / 3600000.0)
    // annotation(Placement(visible = true, transformation(origin = {26, -44},
    //extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Blocks.Tables.CombiTable1Dv toLimTau(
      tableOnFile=mapsOnFile,
      table=maxIceTau,
      tableName=maxTauName,
      fileName=mapsFileName) annotation (Placement(visible=true,
          transformation(
          origin={-72,66},
          extent={{10,-10},{-10,10}},
          rotation=180)));
    Modelica.Blocks.Sources.RealExpression rotorW(y = w.w) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-88, 36})));
    Modelica.Blocks.Math.Gain tokW(k = 1e-3) annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {0, -18})));
    Modelica.Blocks.Tables.CombiTable2Ds toSpecCons(
      tableOnFile=mapsOnFile,
      table=specificConsTab,
      tableName=specConsName,
      fileName=mapsFileName) annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={40,0})));
  equation
    connect(toPow0.u1, w.w) annotation (
      Line(points = {{6, 24}, {6, 33}, {52, 33}}, color = {0, 0, 127}));
    connect(w.flange, inertia.flange_b) annotation (
      Line(points = {{52, 54}, {52, 60}, {36, 60}}));
    connect(icePow.flange_a, inertia.flange_b) annotation (
      Line(points = {{66, 60}, {36, 60}}));
    connect(Tice.flange, inertia.flange_a) annotation (
      Line(points = {{8, 60}, {16, 60}}));
    connect(icePow.flange_b, flange_a) annotation (
      Line(points = {{86, 60}, {94, 60}, {94, 20}, {100, 20}}));
    connect(toLimTau.u[1], rotorW.y) annotation (
      Line(points = {{-84, 66}, {-88, 66}, {-88, 47}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toPow0.y, tokW.u) annotation (
      Line(points = {{-2.22045e-015, 1}, {-2.22045e-015, -2}, {2.22045e-015, -2}, {2.22045e-015, -6}}, color = {0, 0, 127}, smooth = Smooth.None));
    connect(toSpecCons.y, toG_perHour.u1) annotation (
      Line(points = {{40, -11}, {40, -24}, {36, -24}, {36, -38}}, color = {0, 0, 127}));
    connect(toG_perHour.u2, tokW.y) annotation (
      Line(points = {{24, -38}, {24, -32}, {0, -32}, {0, -29}}, color = {0, 0, 127}));
    connect(toSpecCons.u2, w.w) annotation (
      Line(points = {{46, 12}, {46, 28}, {52, 28}, {52, 33}}, color = {0, 0, 127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -80}, {100, 80}})),
      Documentation(info = "<html>
<h4>Basic map-based ICE model.</h4>
<p>It receives as input the reference torque as a fracton of the maximum deliverable torque at a given speed. It can be approximately thought as a signal proportional to the accelerator position oF the vehicle.</p>
<p>The generated torque is the minimum between this signal and the maximum deliverable torque at the actual engine speed (defined by means of a table).</p>
<p>From the generated torque and speed the fuel consumption is computed.</p>
<p>The used maxTorque (toLimTau) and specific fuel consumption (toSpecCons) maps are inspired to public data related to the Toyota Prius&apos; engine </p>
</html>"),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(extent = {{-100, 80}, {100, -80}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-24, 68}, {76, -24}}), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{76, 30}, {100, 10}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 68}, {-32, -26}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-90, 22}, {-32, 0}}), Line(points = {{-60, 56}, {-60, 32}}), Polygon(points = {{-60, 66}, {-66, 56}, {-54, 56}, {-60, 66}}), Polygon(points = {{-60, 24}, {-66, 34}, {-54, 34}, {-60, 24}}), Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, extent = {{-64, 0}, {-54, -20}})}));
  end PartialMBice;

  partial model PartialMBiceP "Simple map-based ice model with connector and Power request"
    import Modelica.Constants.*;
    parameter Real contrGain(unit = "N.m/W") = 0.1 "Proportional controller gain ";
    parameter Modelica.Units.SI.AngularVelocity wIceStart=167;
    parameter Modelica.Units.SI.MomentOfInertia iceJ=0.5
      "ICE moment of Inertia";
    parameter Boolean mapsOnFile = false "= true, if tables are taken from a txt file";
    parameter String mapsFileName = "NoName" "File where matrix is stored" annotation (
      Dialog(enable = mapsOnFile, loadSelector(filter = "Text files (*.txt)", caption = "Open file in which required tables are")));
    parameter String specConsName = "noName" "name of the on-file specific consumption variable" annotation (
      Dialog(enable = mapsOnFile));
    parameter Real specificCons[:, :](each unit = "g/(kW.h)") = [0.0, 100, 200, 300, 400, 500; 10, 630, 580, 550, 580, 630; 20, 430, 420, 400, 400, 450; 30, 320, 325, 330, 340, 350; 40, 285, 285, 288, 290, 300; 50, 270, 265, 265, 270, 275; 60, 255, 248, 250, 255, 258; 70, 245, 237, 238, 243, 246; 80, 245, 230, 233, 237, 240; 90, 235, 230, 228, 233, 235] "ICE specific consumption map. First column torque, first row speed" annotation (
      Dialog(enable = not mapsOnFile));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(w(fixed = true, start = wIceStart, displayUnit = "rpm"), J = iceJ) annotation (
      Placement(visible = true, transformation(extent = {{30, 42}, {50, 62}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sources.Torque iceTau annotation (
      Placement(visible = true, transformation(extent = {{4, 42}, {24, 62}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Sensors.PowerSensor Pice annotation (
      Placement(transformation(extent = {{66, 62}, {86, 42}})));
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor w annotation (
      Placement(visible = true, transformation(origin = {56, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Blocks.Math.Product toPow0 annotation (
      Placement(visible = true, transformation(origin = {-10, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Math.Feedback feedback annotation (
      Placement(transformation(extent = {{-90, 62}, {-70, 42}})));
    Modelica.Blocks.Math.Gain gain(k = contrGain) annotation (
      Placement(visible = true, transformation(extent = {{-62, 42}, {-42, 62}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
    Modelica.Blocks.Tables.CombiTable2Ds toGramsPerKWh(
      table=specificCons,
      tableOnFile=mapsOnFile,
      tableName=specConsName,
      fileName=mapsFileName) annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={42,-2})));
    Modelica.Blocks.Math.Gain tokW(k = 1e-3) annotation (
      Placement(visible = true, transformation(origin = {-10, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=1e99, uMin=0)
      annotation (Placement(visible=true, transformation(
          origin={-22,52},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Modelica.Blocks.Math.Product toG_perHour annotation (
      Placement(visible = true, transformation(origin = {24, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  equation
    connect(toPow0.u2, iceTau.tau) annotation (
      Line(points = {{-16, 20}, {-16, 34}, {-6, 34}, {-6, 52}, {2, 52}}, color = {0, 0, 127}));
    connect(iceTau.tau, limiter1.y) annotation (
      Line(points = {{2, 52}, {-12, 52}, {-12, 52}, {-11, 52}}, color = {0, 0, 127}));
    connect(limiter1.u, gain.y) annotation (
      Line(points = {{-34, 52}, {-42, 52}, {-42, 52}, {-41, 52}}, color = {0, 0, 127}));
    connect(toGramsPerKWh.y, toG_perHour.u1) annotation (
      Line(points = {{42, -13}, {42, -20}, {30, -20}, {30, -38}}, color = {0, 0, 127}));
    connect(tokW.y, toG_perHour.u2) annotation (
      Line(points = {{-10, -33}, {10, -33}, {10, -20}, {18, -20}, {18, -38}}, color = {0, 0, 127}));
    connect(tokW.u, toPow0.y) annotation (
      Line(points = {{-10, -10}, {-10, -3}}, color = {0, 0, 127}));
    connect(toPow0.u2, toGramsPerKWh.u1) annotation (
      Line(points = {{-16, 20}, {-16, 34}, {36, 34}, {36, 10}}, color = {0, 0, 127}));
    connect(toPow0.u1, w.w) annotation (
      Line(points = {{-4, 20}, {-4, 25}, {56, 25}}, color = {0, 0, 127}));
    connect(iceTau.flange, inertia.flange_a) annotation (
      Line(points = {{24, 52}, {30, 52}}));
    connect(toGramsPerKWh.u2, w.w) annotation (
      Line(points = {{48, 10}, {48, 20}, {56, 20}, {56, 25}}, color = {0, 0, 127}));
    connect(w.flange, inertia.flange_b) annotation (
      Line(points = {{56, 46}, {56, 52}, {50, 52}}));
    connect(Pice.flange_a, inertia.flange_b) annotation (
      Line(points = {{66, 52}, {50, 52}}));
    connect(gain.u, feedback.y) annotation (
      Line(points = {{-64, 52}, {-71, 52}}, color = {0, 0, 127}));
    connect(Pice.flange_b, flange_a) annotation (
      Line(points = {{86, 52}, {94, 52}, {94, 0}, {100, 0}}, color = {0, 0, 0}, smooth = Smooth.None));
    connect(feedback.u2, Pice.power) annotation (
      Line(points = {{-80, 60}, {-80, 72}, {68, 72}, {68, 63}}, color = {0, 0, 127}, smooth = Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -60}, {100, 80}}), graphics={  Text(extent = {{-78, 6}, {-38, -16}}, textString = "follows the power
 reference and
 computes consumption")}),
      Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</b> </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is a &QUOT;connector&QUOT; version of MBice.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For a general descritiption see the info of MBice.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Signals connected to the connector:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowRef (input) is the power request (W). Negative values are internally converted to zero</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- iceW (output) is the measured ICE speed (rad/s)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- icePowDel (output) delivered power (W)</span></p>
</html>"),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Rectangle(fillColor = {192, 192, 192},
              fillPattern =  FillPattern.HorizontalCylinder, extent = {{-24, 48}, {76, -44}}), Rectangle(fillColor = {192, 192, 192},
              fillPattern =  FillPattern.HorizontalCylinder, extent = {{76, 10}, {100, -10}}), Text(origin = {-2, 0}, extent = {{-140, -52}, {140, -90}}, textString = "J=%J"), Rectangle(extent = {{-100, 62}, {100, -100}}), Text(origin = {0, 10}, lineColor = {0, 0, 255}, extent = {{-140, 100}, {140, 60}}, textString = "%name"), Rectangle(extent = {{-90, 48}, {-32, -46}}), Rectangle(fillColor = {95, 95, 95},
              fillPattern =  FillPattern.Solid, extent = {{-90, 2}, {-32, -20}}), Line(points = {{-60, 36}, {-60, 12}}), Polygon(points = {{-60, 46}, {-66, 36}, {-54, 36}, {-60, 46}}), Polygon(points = {{-60, 4}, {-66, 14}, {-54, 14}, {-60, 4}}), Rectangle(fillColor = {135, 135, 135},
              fillPattern =  FillPattern.Solid, extent = {{-64, -20}, {-54, -40}})}));
  end PartialMBiceP;

end Partial;
