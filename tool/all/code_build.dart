// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.all.code_build;

import '../iterable/code_build.dart' as iterable_code;
import '../plural/code_build.dart' as plural_code;
import '../relative_time/code_build.dart' as relative_time_code;

main() {
  iterable_code.main()
  .then((_) => plural_code.main())
  .then((_) => relative_time_code.main());
}