import cv2
import numpy as np

font = cv2.FONT_HERSHEY_COMPLEX

wid = 720
heig = 1280
while True:
    # Reads the frame
    frame = cv2.imread("Finalfinal.jpg")
    # frame = cv2.resize(frame, (wid, heig))
    # reduces any image noise
    blurred = cv2.GaussianBlur(frame, (5, 5), 0)
    # converts that image to HSV according to the RGB values of each pixel
    hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
    # Stores an array of lower and higher HSVs
    l_b = np.array([80, 130, 0])
    u_b = np.array([255, 255, 255])
    # creates a mask of the particular lower and higher values on the hsv image
    mask = cv2.inRange(hsv, l_b, u_b)
    # chooses only the masked image from the original frame
    result = cv2.bitwise_and(frame, frame, mask=mask)
    # finds the contours for better analysis of the particular masked object
    contours, hierarchy = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

    rectangle_bgr = (255, 255, 255)

    for contour in contours:
        # finds the moments of those continuous points in the contour
        M = cv2.moments(contour)
        if not M["m00"]:
            continue
        #     Finds the x and y coordinates of the center of the contours
        cX = int(M["m10"] / M["m00"])
        cY = int(M["m01"] / M["m00"])

        # draws the contours on the resulting image
        cv2.drawContours(result, [contour], -1, (255, 255, 255), 1)
        center = cv2.circle(result, (cX, cY), 2, (255, 255, 255), -1)
        print("Cx = ", cX, "Cy = ", cY)
        # extracts the particular colours of the center of the image
        blue = frame[cX, cY, 0]
        green = frame[cX, cY, 1]
        red = frame[cX, cY, 2]
        # print("0", blue)
        # print("1", green)
        # print("2", red)
        # calculates temperature according to the conversion formula
        temp = blue + (green * 256) + (red * 256 * 256)
        temp = int(temp * 0.5960464832810451555875)
        # temperature of center of image
        if temp == 1702206:
            continue
        box_coords = ((cX, cY), (cX + 170, cY - 28))
        cv2.rectangle(frame, box_coords[0], box_coords[1], rectangle_bgr, cv2.FILLED)
        cv2.putText(frame, str(temp) + "K", (cX, cY), font, 1, (0, 0, 0), 2)

        print("Temperature = ", temp)

    cv2.imshow("Original", frame)
    cv2.imshow("RESULT", result)
    cv2.imshow("Mask", mask)
    cv2.imshow("HSVimage", hsv)
    # cv2.imwrite("OriginalImage.jpg", frame)
    # cv2.imwrite("Result.jpg", result)

    key = cv2.waitKey(1)
    if key == 27:
        break
cv2.destroyAllWindows()
