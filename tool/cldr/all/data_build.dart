// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.cldr.tool.all.data_build;

import '../iterable/data_build.dart' as iterable_data;
import '../plural/data_build.dart' as plural_data;
import '../relative_time/data_build.dart' as relative_time_data;

main() {
  iterable_data.main()
  .then((_) => plural_data.main())
  .then((_) => relative_time_data.main());
}
