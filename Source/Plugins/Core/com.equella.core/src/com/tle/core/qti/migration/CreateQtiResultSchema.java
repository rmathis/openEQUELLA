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

package com.tle.core.qti.migration;

import com.google.common.collect.Sets;
import com.tle.beans.Institution;
import com.tle.common.qti.entity.QtiAbstractResult;
import com.tle.common.qti.entity.QtiAssessmentItem;
import com.tle.common.qti.entity.QtiAssessmentItemRef;
import com.tle.common.qti.entity.QtiAssessmentResult;
import com.tle.common.qti.entity.QtiAssessmentTest;
import com.tle.common.qti.entity.QtiItemResult;
import com.tle.common.qti.entity.QtiItemVariable;
import com.tle.core.guice.Bind;
import com.tle.core.hibernate.impl.HibernateCreationFilter;
import com.tle.core.hibernate.impl.HibernateMigrationHelper;
import com.tle.core.hibernate.impl.TablesOnlyFilter;
import com.tle.core.migration.AbstractCreateMigration;
import com.tle.core.migration.ClassDependencies;
import com.tle.core.migration.MigrationInfo;
import com.tle.core.plugins.impl.PluginServiceImpl;
import java.util.Set;
import javax.inject.Singleton;

/**
 * Creates the Result schema for permanently recording student responses
 *
 * @author Aaron
 */
@SuppressWarnings("nls")
@Bind
@Singleton
public class CreateQtiResultSchema extends AbstractCreateMigration {
  private static final String keyPrefix =
      PluginServiceImpl.getMyPluginId(CreateQtiResultSchema.class)
          + ".migration.createresultschema.";

  @Override
  public MigrationInfo createMigrationInfo() {
    return new MigrationInfo(keyPrefix + "title");
  }

  @Override
  protected HibernateCreationFilter getFilter(HibernateMigrationHelper helper) {
    return new TablesOnlyFilter(
        new String[] {
          "qti_abstract_result",
          "qti_assessment_result",
          "qti_item_result",
          "qti_item_variable",
          "qti_item_variable_value"
        });
  }

  @Override
  protected Class<?>[] getDomainClasses() {
    final Set<Class<?>> domainClasses = Sets.newHashSet();
    domainClasses.add(QtiAssessmentItem.class);
    domainClasses.add(QtiAssessmentItemRef.class);
    domainClasses.add(QtiAssessmentTest.class);
    domainClasses.add(Institution.class);
    domainClasses.addAll(ClassDependencies.item());
    domainClasses.add(QtiAbstractResult.class);
    domainClasses.add(QtiAssessmentResult.class);
    domainClasses.add(QtiItemResult.class);
    domainClasses.add(QtiItemVariable.class);
    return domainClasses.toArray(new Class<?>[domainClasses.size()]);
  }
}
