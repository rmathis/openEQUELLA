/*
 * Licensed to The Apereo Foundation under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional
 * information regarding copyright ownership.
 *
 * The Apereo Foundation licenses this file to you under the Apache License,
 * Version 2.0, (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tle.core.services;

import com.tle.common.Pair;
import java.io.Serializable;
import java.util.List;

public interface TaskStatus {
  int getDoneWork();

  int getMaxWork();

  String getErrorMessage();

  boolean isFinished();

  <T extends Serializable> List<T> getTaskLog();

  <T extends Serializable> Pair<Integer, List<T>> getTaskLog(int offset, int maxSize);

  String getInternalId();

  String getTitleKey();

  String getStatusKey();

  int getPercentage();

  <T> T consumeTransient(String key);

  <T> T getTaskSubStatus(String key);

  String getNodeIdRunning();
}
