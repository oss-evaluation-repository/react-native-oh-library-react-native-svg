/**
 * MIT License
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { Descriptor, RNOHContext, ViewDescriptorWrapperBase } from '@rnoh/react-native-openharmony'
import Logger from '../common/log/Logger'
import { SVGPathProps, SVGViewCommon, SVGViewRawCommon, SVGBaseRawProps, SVGState } from '../common/SVGType'
import { SVGPathModifier } from '../attributeModifiers/SVGPathModifier'

export const SVG_PATH_TYPE_NAME: string = "RNSVGPath"

export type SVGPathDescriptor = Descriptor<"RNSVGPath", SVGPathProps, SVGState, SVGBaseRawProps>

export class SVGPathDescriptorWrapper extends ViewDescriptorWrapperBase<"RNSVGPath", SVGPathProps> {
}

@Component
export struct SVGPath {
  ctx!: RNOHContext
  tag: number = 0
  @Consume svgViewCommon: SVGViewRawCommon | undefined
  @State descriptor: SVGPathDescriptor = Object() as SVGPathDescriptor
  @State descriptorWrapper: SVGPathDescriptorWrapper | undefined = undefined
  private unregisterDescriptorChangesListener?: () => void = undefined

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<SVGPathDescriptor>(this.tag)
    this.setDescriptorWrapper(this.descriptor)
    this.unregisterDescriptorChangesListener = this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
      this.descriptor = newDescriptor as SVGPathDescriptor
      this.setDescriptorWrapper(this.descriptor)
      Logger.debug("RNOH SVGPath New", JSON.stringify(this.descriptor))
    })
    Logger.debug("RNOH SVGPath", JSON.stringify(this.descriptor))
  }

  aboutToDisappear() {
    this.unregisterDescriptorChangesListener?.()
  }

  setDescriptorWrapper(descriptor: SVGPathDescriptor) {
    this.descriptorWrapper = new SVGPathDescriptorWrapper(descriptor)
  }

  build() {
    Path()
      .attributeModifier(SVGPathModifier.getInstance()
        .setDescriptor(this.descriptor, this.descriptorWrapper, this.svgViewCommon))
  }
}