package com.daesang.pixel.model;

import java.util.List;
import com.daesang.pixel.model.Pixel;

public interface PixelMapper {

	Pixel getPixel(String pixel);
    List<Pixel> getPixel();
}