// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library cldr.ldml2json_converter_command;

import 'package:path/path.dart';
import 'package:cldr/cldr_installation.dart';
import 'package:cldr/src/java.dart';

class Ldml2JsonConverterCommand extends JavaCommand {

  final String cldrSubdirectory;
  final String config;
  final String out;
  final CldrInstallation installation;

  /// The java class qualified name.
  static final JAVA_CLASS_QUALIFIED_NAME =
      'org.unicode.cldr.json.$JAVA_CLASS_SIMPLE_NAME';

  /// The java class qualified name.
  static final JAVA_CLASS_SIMPLE_NAME = 'Ldml2JsonConverter';

  static final CLDR_SUBDIRECTORIES = ['main', 'supplemental'];
  Ldml2JsonConverterCommand(
      CldrInstallation installation,
      this.cldrSubdirectory,
      this.config,
      this.out)
      : this.installation = installation,
        super(
            JAVA_CLASS_QUALIFIED_NAME,
            systemProperties: {'CLDR_DIR' : installation.path},
            classPath: installation.classPath);

  /// The args to pass to the java class.
  ///
  /// Description from README in http://unicode.org/Public/cldr/23.1/json.zip:
  ///
  /// Usage: Ldml2JsonConverter [OPTIONS] [FILES]
  /// This program converts CLDR data to the JSON format.
  /// Please refer to the following options.
  ///         example: org.unicode.cldr.json.Ldml2JsonConverter -c xxx -d yyy
  /// Here are the options:
  /// -h (help)       no-arg  Provide the list of possible options
  /// -c (commondir)  .*      Common directory for CLDR files, defaults to CldrUtility.COMMON_DIRECTORY
  /// -d (destdir)    .*      Destination directory for output files, defaults to CldrUtility.GEN_DIRECTORY
  /// -m (match)      .*      Regular expression to define only specific locales or files to be generated
  /// -t (type)       (main|supplemental)     Type of CLDR data being generated, main or supplemental.
  /// -r (resolved)   (true|false)    Whether the output JSON for the main directory should be based on resolved or unresolved data
  /// -s (draftstatus)        (approved|contributed|provisional|unconfirmed)  The minimum draft status of the output data
  /// -l (coverage)   (minimal|basic|moderate|modern|comprehensive|optional)  The maximum coverage level of the output data
  /// -n (fullnumbers)        (true|false)    Whether the output JSON should output data for all numbering systems, even those not used in the locale
  /// -o (other)      (true|false)    Whether to write out the 'other' section, which contains any unmatched paths
  /// -k (konfig)     .*      LDML to JSON configuration file
  List<String> get classArguments {
    var args = [
      // The 'supplemental' directory is added automatically.
      '--destdir', cldrSubdirectory == 'main' ? join(out, cldrSubdirectory) : out,
      '--type', cldrSubdirectory,
      '--resolved', 'true'
    ];
    if(config != null) {
      args.addAll(['--konfig', config]);
    }
    return args;
  }
}
