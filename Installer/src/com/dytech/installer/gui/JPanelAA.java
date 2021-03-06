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

package com.dytech.installer.gui;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.LayoutManager;
import java.awt.RenderingHints;
import javax.swing.JPanel;

/**
 * A JPanel which makes all it's child components have smooth, anti-aliased text.
 *
 * @author Nicholas Read
 */
public class JPanelAA extends JPanel {
  public JPanelAA() {
    super();
  }

  public JPanelAA(boolean isDoubleBuffered) {
    super(isDoubleBuffered);
  }

  public JPanelAA(LayoutManager layout) {
    super(layout);
  }

  public JPanelAA(LayoutManager layout, boolean isDoubleBuffered) {
    super(layout, isDoubleBuffered);
  }

  @Override
  public void paint(Graphics g) {
    Graphics2D g2 = (Graphics2D) g;

    g2.setRenderingHint(
        RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

    super.paint(g2);
  }
}
